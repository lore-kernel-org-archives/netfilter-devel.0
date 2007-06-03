From: Akinobu Mita <akinobu.mita@gmail.com>
Subject: [PATCH] nf_conntrack_amanda: fix textsearch_prepare() error check
Date: Sun, 3 Jun 2007 21:00:30 +0900
Message-ID: <20070603120030.GA876@APFDCB5C>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

The return value from textsearch_prepare() needs to be checked
by IS_ERR(). Because it returns error code as a pointer.

Cc: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>

---
 net/netfilter/nf_conntrack_amanda.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

Index: 2.6-mm/net/netfilter/nf_conntrack_amanda.c
===================================================================
--- 2.6-mm.orig/net/netfilter/nf_conntrack_amanda.c
+++ 2.6-mm/net/netfilter/nf_conntrack_amanda.c
@@ -208,13 +208,14 @@ static int __init nf_conntrack_amanda_in
 {
 	int ret, i;
 
-	ret = -ENOMEM;
 	for (i = 0; i < ARRAY_SIZE(search); i++) {
 		search[i].ts = textsearch_prepare(ts_algo, search[i].string,
 						  search[i].len,
 						  GFP_KERNEL, TS_AUTOLOAD);
-		if (search[i].ts == NULL)
+		if (IS_ERR(search[i].ts)) {
+			ret = PTR_ERR(search[i].ts);
 			goto err1;
+		}
 	}
 	ret = nf_conntrack_helper_register(&amanda_helper[0]);
 	if (ret < 0)
@@ -227,10 +228,9 @@ static int __init nf_conntrack_amanda_in
 err2:
 	nf_conntrack_helper_unregister(&amanda_helper[0]);
 err1:
-	for (; i >= 0; i--) {
-		if (search[i].ts)
-			textsearch_destroy(search[i].ts);
-	}
+	while (--i >= 0)
+		textsearch_destroy(search[i].ts);
+
 	return ret;
 }
 
