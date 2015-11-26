From: Linmujia <linmujia@huawei.com>
Subject: [nft] add default branch for code integrality
Date: Thu, 26 Nov 2015 03:09:53 +0000
Message-ID: <0A900C78B9F2324AB7F4F7A51D1A2F8577978285@szxema505-mbs.china.huawei.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
To: "pablo@netfilter.org" <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from szxga01-in.huawei.com ([58.251.152.64]:27051 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751651AbbKZDMD convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Nov 2015 22:12:03 -0500
Content-Language: zh-CN
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,I reviewed nftables code and add some default branch for code itegrality.
Thanks!



Signed-off-by: linmujia <linmujia@huawei.com>
---
 src/netlink.c | 27 ++++++++++++++++++++++++---
 1 file changed, 24 insertions(+), 3 deletions(-)

diff --git a/src/netlink.c b/src/netlink.c
index 974afb1..c6dc2ed 100644
--- a/src/netlink.c
+++ b/src/netlink.c
@@ -307,6 +307,8 @@ static void netlink_gen_verdict(const struct expr *expr,
 		strncpy(data->chain, expr->chain, NFT_CHAIN_MAXNAMELEN);
 		data->chain[NFT_CHAIN_MAXNAMELEN-1] = '\0';
 		break;
+	default:
+		BUG("invalid verdict value %u\n", expr->verdict);
 	}
 }
 
@@ -1670,6 +1672,8 @@ static uint32_t netlink_msg2nftnl_of(uint32_t msg)
 	case NFT_MSG_DELSETELEM:
 	case NFT_MSG_DELRULE:
 		return NFTNL_OF_EVENT_DEL;
+	default:
+		break;
 	}
 
 	return 0;
@@ -1741,6 +1745,8 @@ static int netlink_events_table_cb(const struct nlmsghdr *nlh, int type,
 				  netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
 		break;
+	default:
+		break;
 	}
 
 	nftnl_table_free(nlt);
@@ -1778,14 +1784,17 @@ static int netlink_events_chain_cb(const struct nlmsghdr *nlh, int type,
 			       nftnl_chain_get_str(nlc,
 						      NFTNL_CHAIN_NAME));
 			break;
+		default:
+			break;
 		}
-		break;
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 		nftnl_chain_fprintf(stdout, nlc, monh->format,
 				  netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
 		break;
+	default:
+		break;
 	}
 
 	nftnl_chain_free(nlc);
@@ -1826,14 +1835,17 @@ static int netlink_events_set_cb(const struct nlmsghdr *nlh, int type,
 			       nftnl_set_get_str(nls, NFTNL_SET_TABLE),
 			       nftnl_set_get_str(nls, NFTNL_SET_NAME));
 			break;
+		default:
+			break;
 		}
-		break;
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 		nftnl_set_fprintf(stdout, nls, monh->format,
 				netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
 		break;
+	default:
+		break;
 	}
 out:
 	nftnl_set_free(nls);
@@ -1914,6 +1926,8 @@ static int netlink_events_setelem_cb(const struct nlmsghdr *nlh, int type,
 				netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
 		break;
+	default:
+		break;
 	}
 out:
 	nftnl_set_free(nls);
@@ -1961,14 +1975,17 @@ static int netlink_events_rule_cb(const struct nlmsghdr *nlh, int type,
 			printf("delete rule %s %s %s handle %u\n",
 			       family, table, chain, (unsigned int)handle);
 			break;
+		default:
+			break;
 		}
-		break;
 	case NFTNL_OUTPUT_XML:
 	case NFTNL_OUTPUT_JSON:
 		nftnl_rule_fprintf(stdout, nlr, monh->format,
 				 netlink_msg2nftnl_of(type));
 		fprintf(stdout, "\n");
 		break;
+	default:
+		break;
 	}
 
 	nftnl_rule_free(nlr);
@@ -2122,6 +2139,8 @@ static void netlink_events_cache_update(struct netlink_mon_handler *monh,
 		/* there are no notification for anon-set deletion */
 		netlink_events_cache_delsets(monh, nlh);
 		break;
+	default:
+		break;
 	}
 }
 
@@ -2157,6 +2176,8 @@ static int netlink_events_cb(const struct nlmsghdr *nlh, void *data)
 	case NFT_MSG_DELRULE:
 		ret = netlink_events_rule_cb(nlh, type, monh);
 		break;
+	default:
+		break;
 	}
 	fflush(stdout);
 
-- 
2.5.1.windows.1

