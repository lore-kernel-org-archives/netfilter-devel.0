From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: bug: -j REDIRECT broken with bridge in 2.6.0-test3
Date: Sat, 18 Oct 2003 22:48:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200310182248.08306.bdschuym@pandora.be>
References: <3F3AEDEF.2000108@metavize.com> <3F81E91F.5090304@metavize.com> <20031007100015.GO18246@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>,
	Dirk Morris <dmorris@metavize.com>
In-Reply-To: <20031007100015.GO18246@sunbeam.de.gnumonks.org>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tuesday 07 October 2003 12:00, Harald Welte wrote:
> On Mon, Oct 06, 2003 at 03:13:51PM -0700, Dirk Morris wrote:
> > This is still present in 2.6.0-test6.
> > I'm more than willing to help find this issue if someone gives me a
> > pointer to go on.
> > Narrowing it down to the changes in kernel versions is impossible due to
> > the fact that the bridge wasnt working at all for quite a while.
>
> I'm really sorry, but I don't have any 'easy' instructions on how to
> hunt this down.  I've now added it to my TODO list, but I'm not sure
> when I'll be able to dig into that problem.

Hi, I finally got time to take a good look at this bug and it turns out I
am the one who introduced it.
The fix for it is below. I'll send it to Dave myself.
So Harald, you can remove it from your TODO list. My apologies for the
late fix, I had no idea it would be such an easy fix.

cheers,
Bart


--- linux-2.6.0-test8/net/bridge/br_netfilter.c.old	2003-10-18 22:40:31.000000000 +0200
+++ linux-2.6.0-test8/net/bridge/br_netfilter.c	2003-10-18 22:41:08.000000000 +0200
@@ -217,6 +217,7 @@ bridged_dnat:
 			}
 			memcpy(skb->mac.ethernet->h_dest, dev->dev_addr,
 			       ETH_ALEN);
+			skb->pkt_type = PACKET_HOST;
 		}
 	} else {
 		skb->dst = (struct dst_entry *)&__fake_rtable;
--- linux-2.6.0-test8/net/bridge/netfilter/ebt_redirect.c.old	2003-10-18 22:41:19.000000000 +0200
+++ linux-2.6.0-test8/net/bridge/netfilter/ebt_redirect.c	2003-10-18 22:41:58.000000000 +0200
@@ -34,11 +34,10 @@ static int ebt_target_redirect(struct sk
 	if (hooknr != NF_BR_BROUTING)
 		memcpy((**pskb).mac.ethernet->h_dest,
 		   in->br_port->br->dev->dev_addr, ETH_ALEN);
-	else {
+	else
 		memcpy((**pskb).mac.ethernet->h_dest,
 		   in->dev_addr, ETH_ALEN);
-		(*pskb)->pkt_type = PACKET_HOST;
-	}
+	(*pskb)->pkt_type = PACKET_HOST;
 	return info->target;
 }
 
