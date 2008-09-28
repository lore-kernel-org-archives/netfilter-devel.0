From: "Horton, Dave" <dhorton@pactolus.com>
Subject: RE: been a while...what happened to NFC_ALTERED?
Date: Sun, 28 Sep 2008 11:06:23 -0400
Message-ID: <E8E029BA163C694484CFEA4914619EA2068903F5@pcsexch-bknet>
References: <F6673A17-B622-4F71-AD50-E7E020B3A1C9@pactolus.com> <alpine.LNX.1.10.0809251923040.18190@fbirervta.pbzchgretzou.qr> <E8E029BA163C694484CFEA4914619EA206853DA2@pcsexch-bknet> <alpine.LNX.1.10.0809252108230.17117@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host70.216.41.17.conversent.net ([216.41.17.70]:16659 "EHLO
	pcsexch.ad.pactolus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751464AbYI1PGY convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Sep 2008 11:06:24 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I hope you guys can stick with me and give me a bit more guidance.  I've
made a few changes, but haven't yet got it working.  I don't think I can
take the suggestion of using the dnat target, because I need to see and
process every packet which I understand I can't do with nat.

Not sure if I said this before, but I am installing my target on the
PREROUTING chain and mangle table with a rule like this:

iptables -I PREROUTING 1 -t mangle --proto udp --dport 20000:21000 -j
<my-target> --ports 20000:21000

Secondly, since I last wrote I followed the instructions in the doc Jan
passed me, so that I have now updated my code to xtables. Besides my
target function, I also have a checkentry function to process the
parameters passed from iptables.  I've put in printk debug statements to
verify that the iptables integration and is working fine, and that I am
indeed getting the packets from netfilter which I am.

That brings me to the first of my questions.  Phillip Craig mentioned to
me on a earlier thread that my target function is called from
ipt_local_hook ("In net/ipv4/netfilter/iptable_mangle.c,
ipt_local_hook() saves the the values which affect routing, then
compares them after processing the rules.").  However, I went ahead and
put some printk statements into that function and it doesn't seem like
it is being called for each packet that comes to me.  In other words, I
see my target function getting called lots of times without being called
from ipt_local_hook; I do seem ipt_local_hook being called once or twice
but much less and generally not for packets that are coming to my
target.  Is this because I am hanging my hook off the PREROUTING chain?
Is there different code that calls my target in this case?  The reason I
would like to know is so that I can look at the code and see if it is
examining the changes that I have made to the headers.

So, the current state is that I am getting the packets, changing the ip
destination address and udp port (and ip source address and udp port)
but the packets do not appear to get re-routed and dispatched back to
the network. I even tried explicitly calling ip_route_me_harder from
within my target but that did not change anything.

--Dave
> -----Original Message-----
> From: jengelh@sovereign.computergmbh.de
> [mailto:jengelh@sovereign.computergmbh.de] On Behalf Of Jan Engelhardt
> Sent: Thursday, September 25, 2008 9:13 PM
> To: Horton, Dave
> Cc: netfilter-devel@vger.kernel.org
> Subject: RE: been a while...what happened to NFC_ALTERED?
> 
> 
> On Thursday 2008-09-25 20:47, Horton, Dave wrote:
> >
> >Actually, my code is rather simple.  I've posted it at the bottom of
> >this response.
> >
> >Here is the main piece of my code:
> >
> >		case IPT_PACTOLUS_STATE_FORWARD:
> >
> >
> >			/* modify the source ip:port and the dest
> >ip:port,
> >			 * recalc checksums
> >			 */
> >			udph->source = ptr->new_src_port ;
> >			udph->dest = ptr->new_dst_port ;
> >			if (udph->check) {
> >				u_int32_t newudplen = (*pskb)->len -
> >				  				iph->ihl
> >* 4;
> >
> >				/* calculate checksum of the data
> >portion */
> >				(*pskb)->csum = csum_partial((char
> >*)udph +
> >					sizeof(struct udphdr),
> >					newudplen - sizeof(struct
> >udphdr), 0);
> >				udph->check = 0;
> >				udph->check =
> >csum_tcpudp_magic(iph->daddr,
> >				    	ptr->new_dst_ip,
> >					newudplen, IPPROTO_UDP,
> >					csum_partial((char *)udph,
> >					sizeof(struct udphdr),
> >(*pskb)->csum));
> >			}
> >
> >			iph->saddr = iph->daddr;
> >			iph->daddr = ptr->new_dst_ip;
> 
> You cannot change the IP address or L4 port without making conntrack
> very unhappy. In the simplest case, you're "just" voiding any state
> matching and flow accounting. In the worst case, iph->daddr (and
> other fields) does not match skb->nfct->....->daddr (respectively)
> anymore and cosmic rays could catalyze up, er, undefined behavior
> could arise.
