From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: RE: xt_gateway 20070605 (kernel)
Date: Sat, 16 Jun 2007 09:59:50 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706160953080.32724@fbirervta.pbzchgretzou.qr>
References: <200706160857.l5G8vhv24743@server1.secure-linux-server.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706160857.l5G8vhv24743@server1.secure-linux-server.com>
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


On Jun 16 2007 08:34, Amin Azez wrote:
>>So far I don't intend to merge it, but I'm also not very opposed
>>to it (only reason against it is that its another file to take
>>care of when changing say function signatures and it doesn't
>>offer anything that we can't already do). Its up to you to
>>convince me :)
>
>It does one thing well and simply. For most iptables users, realms is more
>complicated than replicating route information in the nat table.

Well, it is as complicated as policy routing
(e.g. using -j MARK and iproute2's fwmark match)

ip route add 1.3.3.7/32 dev leet0 realm 666
iptables -t nat -A POSTROUTING -m realm --realm 666 -j SNAT --to whatever.

>Realms are perhaps suitable with a large routing infrastructure under one
>administration.
>
>Xt_gateway removes the need for the more advanced explanations of the SNAT
>target that are required from time to time.
>
>Xt_gateway is simple to manage snat when the gateways are out of
>administrative control.
>
>Xt_gateway is persisted solely with iptables-save. There is no iproute-save
>(actually there is, I posted it to the relevant list a few months back but
>no-one noticed).

iproute-save would have a problem: it may interfere with
 (a) 'proto kernel' rules

 (b) rules from the distribution (e.g. /etc/sysconfig/network/ifroutes)
     [lesser a problem]

>I'm not going to try to convince you harder than this. Some directors and
>shareholders (if they were aware) would probably prefer that you did NOT merge
>it to the mainline kernel and I also have a duty to them.

What would they care about how it's done?



	Jan
-- 
