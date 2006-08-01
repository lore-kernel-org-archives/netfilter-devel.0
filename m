From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER]: xt_hashlimit/xt_string: missing string validation
Date: Tue, 01 Aug 2006 08:39:55 +0200
Message-ID: <44CEF73B.8030601@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------080902080502040307000702"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
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

This is a multi-part message in MIME format.
--------------080902080502040307000702
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit



--------------080902080502040307000702
Content-Type: text/plain;
 name="02.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="02.diff"

[NETFILTER]: xt_hashlimit/xt_string: missing string validation

The hashlimit table name and the textsearch algorithm need to be
terminated, the textsearch pattern length must not exceed the
maximum size.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 873fed085b72ad38b565906676ec8fd44e27bb25
tree 0c7cf87c9a95838d3360f11194a960eb915085b3
parent e8b121382d0690c0d92b6134bb60e7626cd49284
author Patrick McHardy <kaber@trash.net> Tue, 01 Aug 2006 08:24:03 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 01 Aug 2006 08:24:03 +0200

 net/ipv4/netfilter/ipt_hashlimit.c |    3 +++
 net/netfilter/xt_string.c          |    5 ++++-
 2 files changed, 7 insertions(+), 1 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_hashlimit.c b/net/ipv4/netfilter/ipt_hashlimit.c
index 92980ab..6b66244 100644
--- a/net/ipv4/netfilter/ipt_hashlimit.c
+++ b/net/ipv4/netfilter/ipt_hashlimit.c
@@ -508,6 +508,9 @@ hashlimit_checkentry(const char *tablena
 	if (!r->cfg.expire)
 		return 0;
 
+	if (r->name[sizeof(r->name) - 1] != '\0')
+		return 0;
+
 	/* This is the best we've got: We cannot release and re-grab lock,
 	 * since checkentry() is called before ip_tables.c grabs ipt_mutex.  
 	 * We also cannot grab the hashtable spinlock, since htable_create will 
diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index 0ebb6ac..d8e3891 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -55,7 +55,10 @@ static int checkentry(const char *tablen
 	/* Damn, can't handle this case properly with iptables... */
 	if (conf->from_offset > conf->to_offset)
 		return 0;
-
+	if (conf->algo[XT_STRING_MAX_ALGO_NAME_SIZE - 1] != '\0')
+	    	return 0;
+	if (conf->patlen > XT_STRING_MAX_PATTERN_SIZE)
+		return 0;
 	ts_conf = textsearch_prepare(conf->algo, conf->pattern, conf->patlen,
 				     GFP_KERNEL, TS_AUTOLOAD);
 	if (IS_ERR(ts_conf))

--------------080902080502040307000702--
