From: Chris Rankin <rankincj@yahoo.com>
Subject: Re: 2.6.12: connection tracking broken?
Date: Wed, 22 Jun 2005 23:58:16 +0100 (BST)
Message-ID: <20050622225816.97752.qmail@web52903.mail.yahoo.com>
References: <42B8B035.7020303@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: chrisw@osdl.org, bdschuym@pandora.be, bdschuym@telenet.be,
	herbert@gondor.apana.org.au, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org, rankincj@yahoo.com,
	ebtables-devel@lists.sourceforge.net, netfilter-devel@manty.net
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262573AbVFVXHf@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>,
	"David S. Miller" <davem@davemloft.net>
In-Reply-To: <42B8B035.7020303@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

--- Patrick McHardy <kaber@trash.net> wrote:
> I would like to get confirmation from someone affected by this
> bug, after that I think it should go in -stable. Chris, could
> you give it a try?

I trust you're talking about the following patches?

diff --git a/net/ipv4/ip_output.c b/net/ipv4/ip_output.c
--- a/net/ipv4/ip_output.c
+++ b/net/ipv4/ip_output.c
@@ -188,7 +188,12 @@ static inline int ip_finish_output2(stru
                skb = skb2;
        }

-       nf_reset(skb);
+#ifdef CONFIG_BRIDGE_NETFILTER
+       /* bridge-netfilter defers calling some IP hooks to the bridge layer and
+        * still needs the conntrack reference */
+       if (skb->nf_bridge == NULL)
+#endif
+               nf_reset(skb);

        if (hh) {
                int hh_alen;

diff --git a/net/bridge/br_netfilter.c b/net/bridge/br_netfilter.c
--- a/net/bridge/br_netfilter.c
+++ b/net/bridge/br_netfilter.c
@@ -882,7 +882,7 @@ static unsigned int ip_sabotage_out(unsi
                 * doesn't use the bridge parent of the indev by using
                 * the BRNF_DONT_TAKE_PARENT mask. */
                if (hook == NF_IP_FORWARD && nf_bridge->physindev == NULL) {
-                       nf_bridge->mask &= BRNF_DONT_TAKE_PARENT;
+                       nf_bridge->mask |= BRNF_DONT_TAKE_PARENT;
                        nf_bridge->physindev = (struct net_device *)in;
                }
 #if defined(CONFIG_VLAN_8021Q) || defined(CONFIG_VLAN_8021Q_MODULE)

I have just installed them, and my bridging firewall is working again with 2.6.12.

Thanks,
Chris



		
___________________________________________________________ 
How much free photo storage do you get? Store your holiday 
snaps for FREE with Yahoo! Photos http://uk.photos.yahoo.com
