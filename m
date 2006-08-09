From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER 01/02]: xt_string: fix negation
Date: Wed, 09 Aug 2006 11:41:24 +0200
Message-ID: <44D9ADC4.1000909@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------010806060602040208050001"
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
--------------010806060602040208050001
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Hi Dave,

following are two small netfilter fixes for 2.6.18.
Please apply, thanks.


--------------010806060602040208050001
Content-Type: text/plain;
 name="01.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="01.diff"

[NETFILTER]: xt_string: fix negation

The xt_string match is broken with ! negation.
This resolves a portion of netfilter bugzilla #497.

Signed-off-by: Phil Oester <kernel@linuxace.com>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 71c55528be7cf1199376a1b1c5489f60bf2b2617
tree 9a3262f5694c8eb859852981536baa874d3b0fab
parent 9f737633e6ee54fc174282d49b2559bd2208391d
author Phil Oester <kaber@trash.net> Tue, 08 Aug 2006 11:09:06 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 08 Aug 2006 11:09:06 +0200

 net/netfilter/xt_string.c |    2 +-
 1 files changed, 1 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/xt_string.c b/net/netfilter/xt_string.c
index d8e3891..275330f 100644
--- a/net/netfilter/xt_string.c
+++ b/net/netfilter/xt_string.c
@@ -37,7 +37,7 @@ static int match(const struct sk_buff *s
 
 	return (skb_find_text((struct sk_buff *)skb, conf->from_offset, 
 			     conf->to_offset, conf->config, &state) 
-			     != UINT_MAX) && !conf->invert;
+			     != UINT_MAX) ^ conf->invert;
 }
 
 #define STRING_TEXT_PRIV(m) ((struct xt_string_info *) m)

--------------010806060602040208050001--
