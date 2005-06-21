From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.12: connection tracking broken?
Date: Tue, 21 Jun 2005 17:16:05 +0200
Message-ID: <42B82F35.3040909@trash.net>
References: <E1Dk9nK-0001ww-00@gondolin.me.apana.org.au>	
	<Pine.LNX.4.62.0506200432100.31737@kaber.coreworks.de>	
	<1119249575.3387.3.camel@localhost.localdomain>
	<42B6B373.20507@trash.net>	
	<1119293193.3381.9.camel@localhost.localdomain>	
	<42B74FC5.3070404@trash.net>
	<1119338382.3390.24.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------000506000503090704000107"
Cc: Bart De Schuymer <bdschuym@telenet.be>,
	Herbert Xu <herbert@gondor.apana.org.au>,
	netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, rankincj@yahoo.com,
	ebtables-devel@lists.sourceforge.net, netfilter-devel@manty.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bart De Schuymer <bdschuym@pandora.be>
In-Reply-To: <1119338382.3390.24.camel@localhost.localdomain>
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
--------------000506000503090704000107
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Bart De Schuymer wrote:
> Deferring the hooks makes the bridge-nf code alot more complicated, so I
> would be glad to get rid of it if it is the right thing to do. But
> backwards compatibility can't be maintained and I'd be surprised if
> every ruleset that now works will still be possible using an
> iptables/ebtables scheme.

I unfortunately don't see a way to remove it, but we should keep
thinking about it. Can you please check if the attached patch is
correct? It should exclude all packets handled by bridge-netfilter
from having their conntrack reference dropped. I didn't add nf_reset()'s
to the bridging code because with tc actions the packets can end up
anywhere else anyway, and this will hopefully get fixed right sometime.

BTW. this line from ip_sabotage_out() looks wrong, it will clear all
flags instead of setting the BRNF_DONT_TAKE_PARENT flag (second
patch):

                        nf_bridge->mask &= BRNF_DONT_TAKE_PARENT;

Signed-off-by: Patrick McHardy <kaber@trash.net>

--------------000506000503090704000107
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -188,7 +188,12 @@ static inline int ip_finish_output2(stru
 		skb = skb2;
 	}
 
-	nf_reset(skb);
+#ifdef CONFIG_BRIDGE_NETFILTER
+	/* bridge-netfilter defers calling some IP hooks to the bridge layer and
+	 * still needs the conntrack reference */
+	if (skb->nf_bridge == NULL)
+#endif
+		nf_reset(skb);
 
 	if (hh) {
 		int hh_alen;

--------------000506000503090704000107
Content-Type: text/x-patch;
 name="10.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="10.diff"

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -882,7 +882,7 @@ static unsigned int ip_sabotage_out(unsi
 		 * doesn't use the bridge parent of the indev by using
 		 * the BRNF_DONT_TAKE_PARENT mask. */
 		if (hook == NF_IP_FORWARD && nf_bridge->physindev == NULL) {
-			nf_bridge->mask &= BRNF_DONT_TAKE_PARENT;
+			nf_bridge->mask |= BRNF_DONT_TAKE_PARENT;
 			nf_bridge->physindev = (struct net_device *)in;
 		}
 #if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)

--------------000506000503090704000107--
