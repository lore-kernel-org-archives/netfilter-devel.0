From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] string match negation fix
Date: Thu, 3 Aug 2006 18:17:40 -0700
Message-ID: <20060804011740.GA1177@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="bg08WKrSYDhXBjb5"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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


--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

The xt_string match is broken with ! negation.

This resolves a portion of netfilter bugzilla #497.

Phil

Signed-off-by: Phil Oester <kernel@linuxace.com>



--bg08WKrSYDhXBjb5
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-string_negate

--- linux-dellfw/net/netfilter/xt_string.c	2006-07-15 15:00:43.000000000 -0400
+++ linux-po/net/netfilter/xt_string.c	2006-08-03 21:06:13.000000000 -0400
@@ -37,7 +37,7 @@
 
 	return (skb_find_text((struct sk_buff *)skb, conf->from_offset, 
 			     conf->to_offset, conf->config, &state) 
-			     != UINT_MAX) && !conf->invert;
+			     != UINT_MAX) ^ conf->invert;
 }
 
 #define STRING_TEXT_PRIV(m) ((struct xt_string_info *) m)

--bg08WKrSYDhXBjb5--
