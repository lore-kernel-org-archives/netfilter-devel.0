From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 03/03]: nf_conntrack_amanda: fix textsearch_prepare()
	error check
Date: Tue,  5 Jun 2007 15:35:12 +0200 (MEST)
Message-ID: <20070605133512.10309.32662.sendpatchset@localhost.localdomain>
References: <20070605133508.10309.36756.sendpatchset@localhost.localdomain>
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: davem@davemloft.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070605133508.10309.36756.sendpatchset@localhost.localdomain>
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

[NETFILTER]: nf_conntrack_amanda: fix textsearch_prepare() error check

The return value from textsearch_prepare() needs to be checked
by IS_ERR(). Because it returns error code as a pointer.

Cc: "Brian J. Murrell" <netfilter@interlinx.bc.ca>
Signed-off-by: Akinobu Mita <akinobu.mita@gmail.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 82224978c778e6e62e9d8d6f03e64d70bc494af4
tree 3107bf5a8fea7361cb0f4abec3ec0877b429d166
parent b14c27ef9486854969ae471aa5818b1e1352a0d7
author Akinobu Mita <akinobu.mita@gmail.com> Tue, 05 Jun 2007 15:33:04 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 05 Jun 2007 15:33:04 +0200

 net/netfilter/nf_conntrack_amanda.c |   12 ++++++------
 1 files changed, 6 insertions(+), 6 deletions(-)

diff --git a/net/netfilter/nf_conntrack_amanda.c b/net/netfilter/nf_conntrack_amanda.c
index b8869ea..0568f2e 100644
--- a/net/netfilter/nf_conntrack_amanda.c
+++ b/net/netfilter/nf_conntrack_amanda.c
@@ -208,13 +208,14 @@ static int __init nf_conntrack_amanda_init(void)
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
@@ -227,10 +228,9 @@ static int __init nf_conntrack_amanda_init(void)
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
 
