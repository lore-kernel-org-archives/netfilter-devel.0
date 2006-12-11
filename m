From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: ROUTE target and conntrack
Date: Mon, 11 Dec 2006 18:41:14 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612111838130.28981@yvahk01.tjqt.qr>
References: <1165848252.2859.11.camel@scaramouche.combox.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-Devel <netfilter-devel@lists.netfilter.org>,
	delaunois@info.ucl.ac.be
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
In-Reply-To: <1165848252.2859.11.camel@scaramouche.combox.de>
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

>
>iptables -A INPUT -p udp -m state --state ESTABLISHED,RELATED -j ACCEPT
>iptables -A INPUT -p udp -j DROP
>
>iptables -t mangle -A POSTROUTING -s $NW1 -j ROUTE --gw $GW1
>
>If I use this instead, it works:
>
>iptables -t mangle -A POSTROUTING -s $NW1 -j ROUTE --gw $GW1 --continue
>iptables -t mangle -A POSTROUTING -s $NW1 -j ACCEPT
>
>Question: is what those 2 lines do (with respect to routing) identical
>to what the one line above does?

>Is it possible to "fix" the ROUTE target so conntracking is not
>bypassed?

Except from ipt_ROUTE.c, all looks normal to me:

                dev_put(dev_out);
                if (route_info->flags & IPT_ROUTE_CONTINUE)
                        return IPT_CONTINUE;

                ip_direct_send(skb);
                return NF_STOLEN;


	-`J'
-- 
