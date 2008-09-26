From: "Horton, Dave" <dhorton@pactolus.com>
Subject: RE: been a while...what happened to NFC_ALTERED?
Date: Thu, 25 Sep 2008 20:47:56 -0400
Message-ID: <E8E029BA163C694484CFEA4914619EA206853DA2@pcsexch-bknet>
References: <F6673A17-B622-4F71-AD50-E7E020B3A1C9@pactolus.com> <alpine.LNX.1.10.0809251923040.18190@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: 8BIT
Cc: <netfilter-devel@vger.kernel.org>
To: "Jan Engelhardt" <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from host70.216.41.17.conversent.net ([216.41.17.70]:3635 "EHLO
	pcsexch.ad.pactolus.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752393AbYIZBDK convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:03:10 -0400
Content-class: urn:content-classes:message
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

> > Here's my situation: I wrote a simple netfilter target a couple of
> > years back, been running it on Redhat 3, 2.4 kernel successfully
> > for quite a while.  I install it on the PREROUTING chain, and I
> > mangle UDP packets; modifiying the source and destination
> > addresses.
> 
> Modifying it in which way? Maybe what you are trying to achieve is
> already solved by other modules.

Actually, my code is rather simple.  I've posted it at the bottom of
this response.

> > My code was then setting the NFC_ALTERED bit in the
> > nf_cache of the sk_buff so that it would get re-processed by
> > netfilter. Everything fine.  Now I simply want to update my code to
> > run on Centos 5, kernel 2.6.18 and iptables 1.4.  Whoa, now I find
> > my kernel module doesn't compile because that data structure has
> > changed.  If I remove that line of code, it compiles, but the
> > packet forwarding does not work (and it seems like I stop getting
> > packets routed to my target at all once I mangle the first one).
> >
> > Can someone help me out?  What is the new improved way of
> > indicating that I've changed a packet's header or body so that
> > netfilter re-examines it?
> 
> The funny thing is, even in Linux 2.5.0, only the IPv6 code ever
> examines for NFC_ALTERED. It's like the thing was never used.
> See http://jengelh.medozas.de/documents/Netfilter_Modules.pdf
> if you need any assistance for moving your extension forward
> in time (though 2.6.18 is now so old again...)

Interesting....I was on linux 2.4 kernel though, if that makes any
difference.  
Many thanks for the pointer to the doc, I will read it now.


Here is the main piece of my code:

static unsigned int
target (struct sk_buff **pskb,
		unsigned int hooknum, const struct net_device *in, 
		const struct net_device *out, const void *targetinfo,
		void *userinfo)
{

	struct iphdr *iph = (*pskb)->nh.iph;
	struct udphdr *udph = (void *)iph + (iph->ihl<<2);
	struct ipt_rtp_tuple *ptr, hold;
	int disposition = IPT_CONTINUE ;

	u_int16_t orig_dest = ntohs(udph->dest) ;

	/* Check if we received the packet on a port that is in the 
	 * range we care about.
	 */
	if (orig_dest >= start_port && orig_dest <= end_port) {
		int entry = orig_dest - start_port ;
		
		//spin_lock(&lock);
		ptr = sip_ua_agents + entry;
		hold = *ptr;
		//spin_unlock(&lock);
		
		ptr = &hold;

		switch( ptr->state ) {
		
		case IPT_PACTOLUS_STATE_DISCARD:
			disposition = NF_DROP ;
			break ;

		case IPT_PACTOLUS_STATE_ACCEPT:
			break ;

		case IPT_PACTOLUS_STATE_FORWARD:


			/* modify the source ip:port and the dest
ip:port, 
			 * recalc checksums 
			 */
			udph->source = ptr->new_src_port ;
			udph->dest = ptr->new_dst_port ;
			if (udph->check) {
				u_int32_t newudplen = (*pskb)->len - 
				  				iph->ihl
* 4;

				/* calculate checksum of the data
portion */
				(*pskb)->csum = csum_partial((char
*)udph +
					sizeof(struct udphdr),
					newudplen - sizeof(struct
udphdr), 0);
				udph->check = 0;
				udph->check =
csum_tcpudp_magic(iph->daddr, 
				    	ptr->new_dst_ip,
					newudplen, IPPROTO_UDP, 
					csum_partial((char *)udph,
					sizeof(struct udphdr),
(*pskb)->csum));
			}

			iph->saddr = iph->daddr;
			iph->daddr = ptr->new_dst_ip;

			iph->check = 0 ;
			iph->check = pcs_cheat_check ((unsigned char
*)iph, 
					sizeof (struct iphdr));

			(*pskb)->nfcache |= NFC_ALTERED;
			break ;

		case IPT_PACTOLUS_STATE_REJECT:
			//TODO: implement
			break ;

		default:
			printk(KERN_ALERT "Unknown state '%d' for port
%d\n", ptr->state, orig_dest ) ;
			break ;
		}
	}
	return disposition;
}
