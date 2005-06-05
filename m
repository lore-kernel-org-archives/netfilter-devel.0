From: knash@cs.tcd.ie
Subject: Re: promiscuous mode
Date: Sun, 5 Jun 2005 17:00:52 +0100 (IST)
Message-ID: <34862.62.231.54.45.1117987252.squirrel@webmail.cs.tcd.ie>
References: <32849.62.231.54.154.1117789778.squirrel@webmail.cs.tcd.ie>
	<42A16B04.5050807@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <42A16B04.5050807@outerspace.dyndns.org>
To: "Jonas Berlin" <xkr47@outerspace.dyndns.org>
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

Jonas,
     Thanks for the info :-). I tried what you suggested by changing the
rp_filter setting but this does not appear to effect the packets I
see at the NF_IP_PRE_ROUTING hook.

Does this mean that rp_filter comes into effect after the
NF_IP_PRE_ROUTING hook and before the NF_IP_LOCAL_IN hook?.

I also set up a socket using the PF_PACKET protocol to make sure that my
network card is in promiscuous mode. This is the case and I can see
unicast packets going to and from one of my other linux boxes.

I've just started working with the linux network protocol stack so my
understanding is fairly limited (and I might have got this wrong) but thi=
s
is what I think is happening:

All the IP packets picked up by my network card are revceived at the
ip_rcv() function (in net/ipv4/ip_input.c)

The very first thing ip_rcv does is check whether the packet is destinted
for another host and if so drops it


/*
 *      Main IP Receive routine.
 */
int ip_rcv(struct sk_buff *skb, struct net_device *dev, struct packet_typ=
e
*pt)
{
        struct iphdr *iph;

   /* When the interface is in promisc. mode, drop all the crap
    * that it receives, do not try to analyse it.
    */
        if (skb->pkt_type =3D=3D PACKET_OTHERHOST)
                goto drop;

At the end of the ip_rcv() function the NF_IP_PRE_ROUTING hook is called

        return NF_HOOK(PF_INET, NF_IP_PRE_ROUTING, skb, dev, NULL,
                      ip_rcv_finish);

By this stage the packets which I want to look at have already been
dropped. So what I need is a hook which can grab these packets received i=
n
promiscuous mode before they are dropped,

Thanks,
Kevin




> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
>
> Quoting knash@cs.tcd.ie on 2005-06-03 09:09 UTC:
>> Hello,
>
> Hi :)
>
>> I set up my wireless card in promiscuous mode. I want to capture all
>> unicast packets using the hook NF_IP_PRE_ROUTING but packets other the=
n
>> the ones destined for my machine are been dropped.
>
> Could it be that you have rp_filter turned on?
>
> Try doing this:
>
>   echo 0 > /proc/sys/net/ipv4/conf/eth1/rp_filter
>
> (replace eth1 with whatever your wlan interface is)
>
> Here's some more info (chapter 13.1):
>
>   http://www.linuxguruz.com/iptables/howto/2.4routing-13.html
>
> - --
> - - xkr47
> -----BEGIN PGP SIGNATURE-----
> Version: GnuPG v1.4.1 (GNU/Linux)
>
> iD8DBQFCoWsCxyF48ZTvn+4RAui4AJ4422QWePo6mfZ1AixtXjDGKAdvSQCgx2jR
> gbBwczPHtnuIDrePPyaq/6k=3D
> =3D+Kry
> -----END PGP SIGNATURE-----
>
>
