import { LightningElement, wire } from 'lwc';
import { gql, graphql } from 'lightning/uiGraphQLApi';
export default class GraphQlDemo1 extends LightningElement {
     accountId = '001dL00000SBW4aQAH';
     results;
     errors;
    get variables() {
        return { id: this.accountId };
    }
    @wire(graphql, {
        query: gql`
            query AccountWithContacts($id: ID!) {
                uiapi {
                    query {
                        Account(where: { Id: { eq: $id } }) {
                            edges {
                                node {
                                    Id
                                    Name {
                                        value
                                    }
                                    Contacts {
                                        edges {
                                            node {
                                                Id
                                                Name {
                                                    value
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
            }
        `,
        variables: '$variables'
    })
    graphqlQueryResult({ data, errors }) {
        if (data) {
            this.results = data.uiapi.query.Account.edges.map((edge) => edge.node);
            console.log('qraph ql results========',JSON.stringify(this.results));
        } else if (errors) {
            this.errors = errors;
        }
    }
}
// import { LightningElement, wire } from 'lwc';
// import { gql, graphql } from 'lightning/uiGraphQLApi';

// export default class GraphQlDemo extends LightningElement {
//     results;
//     errors;

//     @wire(graphql, {
//         query: gql`
//             query AllAccounts {
//                 uiapi {
//                     query {
//                         Account {
//                             edges {
//                                 node {
//                                     Id
//                                     Name {
//                                         value
//                                     }
//                                     CreatedDate {
//                                         value
//                                     }
//                                 }
//                             }
//                         }
//                     }
//                 }
//             }
//         `
//     })
//     graphqlQueryResult({ data, errors }) {
//         if (data) {
//             console.log('data--------', JSON.stringify(data));
            
//         } else if (errors) {
//             this.errors = errors;
//         }
//     }
// }