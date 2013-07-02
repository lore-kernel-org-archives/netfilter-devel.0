From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: [PATCH -stable-3.9 02/15] netfilter: ipt_ULOG: fix non-null terminated string in the nf_log path
Date: Tue,  2 Jul 2013 16:50:52 +0200
Message-ID: <1372776665-6795-2-git-send-email-pablo@netfilter.org>
References: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Cc: davem@davemloft.net, stable@vger.kernel.org
To: netfilter-devel@vger.kernel.org
Return-path: <stable-owner@vger.kernel.org>
In-Reply-To: <1372776665-6795-1-git-send-email-pablo@netfilter.org>
Sender: stable-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Chen Gang <gang.chen@asianux.com>

If nf_log uses ipt_ULOG as logging output, we can deliver non-null
terminated strings to user-space since the maximum length of the
prefix that is passed by nf_log is NF_LOG_PREFIXLEN but pm->prefix
is 32 bytes long (ULOG_PREFIX_LEN).

This is actually happening already from nf_conntrack_tcp if ipt_ULOG
is used, since it is passing strings longer than 32 bytes.

Signed-off-by: Chen Gang <gang.chen@asianux.com>
Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
---
Cherry-pick: 4f36ea6eed2081340c7a7aa98c73187ecfccebff

 net/ipv4/netfilter/ipt_ULOG.c |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_ULOG.c b/net/ipv4/netfilter/ipt_ULOG.c
index 7d168dc..3202b7d 100644
--- a/net/ipv4/netfilter/ipt_ULOG.c
+++ b/net/ipv4/netfilter/ipt_ULOG.c
@@ -215,8 +215,10 @@ static void ipt_ulog_packet(unsigned int hooknum,
 	put_unaligned(tv.tv_usec, &pm->timestamp_usec);
 	put_unaligned(skb->mark, &pm->mark);
 	pm->hook = hooknum;
-	if (prefix != NULL)
-		strncpy(pm->prefix, prefix, sizeof(pm->prefix));
+	if (prefix != NULL) {
+		strncpy(pm->prefix, prefix, sizeof(pm->prefix) - 1);
+		pm->prefix[sizeof(pm->prefix) - 1] = '\0';
+	}
 	else if (loginfo->prefix[0] != '\0')
 		strncpy(pm->prefix, loginfo->prefix, sizeof(pm->prefix));
 	else
-- 
1.7.10.4
