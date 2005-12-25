From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: [PATCH 2/2] conntrack: check address family mismatch
Date: Sun, 25 Dec 2005 16:36:49 +0900 (JST)
Message-ID: <200512250736.jBP7aoU5011122@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: pablo@eurodev.net
Content-Disposition: inline; filename="02-check-family.patch"
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

[CONNTRACK] check address family mismatch

Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>

---
commit ece520fd3d500fb3b67734f2e8b0336fe5a54899
tree a3ef7310549feb8c1d0785f331b27e4e969a96bc
parent dcc6b2fb1e018f7ceda135c731417ce92755bc77
author Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 24 Dec 2005 14:06:46 +0900
committer Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp> Sat, 24 Dec 2005 14:06:46 +0900

 src/conntrack.c |   51 ++++++++++++++++++++++++++++++++++++++++-----------
 1 files changed, 40 insertions(+), 11 deletions(-)

diff --git a/src/conntrack.c b/src/conntrack.c
index 63d2757..a7b4868 100644
--- a/src/conntrack.c
+++ b/src/conntrack.c
@@ -419,6 +419,14 @@ unsigned int check_type(int argc, char *
 	return 0;
 }
 
+static void set_family(int *family, int new)
+{
+	if (*family == AF_UNSPEC)
+		*family = new;
+	else if (*family != new)
+		exit_error(PARAMETER_PROBLEM, "mismatched address family\n");
+}
+
 static char *get_modprobe(void)
 {
 	int procfile;
@@ -662,7 +670,7 @@ int main(int argc, char *argv[])
 	unsigned int id = NFCT_ANY_ID;
 	unsigned int type = 0, extra_flags = 0, event_mask = 0;
 	int res = 0;
-	int family = AF_INET;
+	int family = AF_UNSPEC;
 
 	memset(&proto, 0, sizeof(union nfct_protoinfo));
 	memset(&orig, 0, sizeof(struct nfct_tuple));
@@ -733,27 +741,35 @@ int main(int argc, char *argv[])
 			break;
 		case 's':
 			options |= CT_OPT_ORIG_SRC;
-			if (optarg)
+			if (optarg) {
 				orig.l3protonum =
 					parse_inetaddr(optarg, &orig.src);
+				set_family(&family, orig.l3protonum);
+			}
 			break;
 		case 'd':
 			options |= CT_OPT_ORIG_DST;
-			if (optarg)
+			if (optarg) {
 				orig.l3protonum = 
 					parse_inetaddr(optarg, &orig.dst);
+				set_family(&family, orig.l3protonum);
+			}
 			break;
 		case 'r':
 			options |= CT_OPT_REPL_SRC;
-			if (optarg)
+			if (optarg) {
 				reply.l3protonum = 
 					parse_inetaddr(optarg, &reply.src);
+				set_family(&family, reply.l3protonum);
+			}
 			break;
 		case 'q':
 			options |= CT_OPT_REPL_DST;
-			if (optarg)
+			if (optarg) {
 				reply.l3protonum = 
 					parse_inetaddr(optarg, &reply.dst); 
+				set_family(&family, reply.l3protonum);
+			}
 			break;
 		case 'p':
 			options |= CT_OPT_PROTO;
@@ -789,30 +805,39 @@ int main(int argc, char *argv[])
 			break;
 		case '{':
 			options |= CT_OPT_MASK_SRC;
-			if (optarg)
+			if (optarg) {
 				mask.l3protonum = 
 					parse_inetaddr(optarg, &mask.src);
+				set_family(&family, mask.l3protonum);
+			}
 			break;
 		case '}':
 			options |= CT_OPT_MASK_DST;
-			if (optarg)
+			if (optarg) {
 				mask.l3protonum = 
 					parse_inetaddr(optarg, &mask.dst);
+				set_family(&family, mask.l3protonum);
+			}
 			break;
 		case '[':
 			options |= CT_OPT_EXP_SRC;
-			if (optarg)
+			if (optarg) {
 				exptuple.l3protonum = 
 					parse_inetaddr(optarg, &exptuple.src);
+				set_family(&family, exptuple.l3protonum);
+			}
 			break;
 		case ']':
 			options |= CT_OPT_EXP_DST;
-			if (optarg)
+			if (optarg) {
 				exptuple.l3protonum = 
 					parse_inetaddr(optarg, &exptuple.dst);
+				set_family(&family, exptuple.l3protonum);
+			}
 			break;
 		case 'a':
 			options |= CT_OPT_NATRANGE;
+			set_family(&family, AF_INET);
 			nat_parse(optarg, 1, &range);
 			break;
 		case 'm':
@@ -834,9 +859,9 @@ int main(int argc, char *argv[])
 		case 'f':
 			options |= CT_OPT_FAMILY;
 			if (strncmp(optarg, "ipv4", strlen("ipv4")) == 0)
-				break;
+				set_family(&family, AF_INET);
 			else if (strncmp(optarg, "ipv6", strlen("ipv6")) == 0)
-				family = AF_INET6;
+				set_family(&family, AF_INET6);
 			else
 				exit_error(PARAMETER_PROBLEM, "Unknown "
 					   "protocol family\n");
@@ -858,6 +883,10 @@ int main(int argc, char *argv[])
 		}
 	}
 
+	/* default family */
+	if (family == AF_UNSPEC)
+		family = AF_INET;
+
 	generic_cmd_check(command, options);
 	generic_opt_check(command, options);
 
