From: Patrick McHardy <kaber@trash.net>
Subject: [NETFILTER -stable]: ipt_CLUSTERIP: fix oops in checkentry function
Date: Tue, 10 Apr 2007 14:47:21 +0200
Message-ID: <461B8759.1000507@trash.net>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------060904030800080201050200"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	"David S. Miller" <davem@davemloft.net>
To: stable@kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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
--------------060904030800080201050200
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit

Fix netfilter crash in ipt_CLUSTERIP. Please apply.


--------------060904030800080201050200
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

[NETFILTER]: ipt_CLUSTERIP: fix oops in checkentry function

The clusterip_config_find_get() already increases entries reference
counter, so there is no reason to do it twice in checkentry() callback.

This causes the config to be freed before it is removed from the list,
resulting in a crash when adding the next rule.

Signed-off-by: Jaroslav Kysela <perex@suse.cz>
Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 587ef6fd51ede13f0b3437910d5ecefb980461ed
tree df06064ff57ee2ddcd4b47d8a7450c7f797fa230
parent fea42a5760325392653d556b1087f8274adcfb2e
author Jaroslav Kysela <perex@suse.cz> Tue, 10 Apr 2007 14:42:29 +0200
committer Patrick McHardy <kaber@trash.net> Tue, 10 Apr 2007 14:42:29 +0200

 net/ipv4/netfilter/ipt_CLUSTERIP.c |    2 --
 1 files changed, 0 insertions(+), 2 deletions(-)

diff --git a/net/ipv4/netfilter/ipt_CLUSTERIP.c b/net/ipv4/netfilter/ipt_CLUSTERIP.c
index e965b33..42b0802 100644
--- a/net/ipv4/netfilter/ipt_CLUSTERIP.c
+++ b/net/ipv4/netfilter/ipt_CLUSTERIP.c
@@ -411,12 +411,10 @@ checkentry(const char *tablename,
 				       "has invalid config pointer!\n");
 				return 0;
 			}
-			clusterip_config_entry_get(cipinfo->config);
 		} else {
 			/* Case B: This is a new rule referring to an existing
 			 * clusterip config. */
 			cipinfo->config = config;
-			clusterip_config_entry_get(cipinfo->config);
 		}
 	} else {
 		/* Case C: This is a completely new clusterip config */

--------------060904030800080201050200--
