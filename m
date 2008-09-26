From: Jan Engelhardt <jengelh@medozas.de>
Subject: RE: been a while...what happened to NFC_ALTERED?
Date: Thu, 25 Sep 2008 21:12:33 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0809252108230.17117@fbirervta.pbzchgretzou.qr>
References: <F6673A17-B622-4F71-AD50-E7E020B3A1C9@pactolus.com> <alpine.LNX.1.10.0809251923040.18190@fbirervta.pbzchgretzou.qr> <E8E029BA163C694484CFEA4914619EA206853DA2@pcsexch-bknet>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: "Horton, Dave" <dhorton@pactolus.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:47769 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489AbYIZBMe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 25 Sep 2008 21:12:34 -0400
In-Reply-To: <E8E029BA163C694484CFEA4914619EA206853DA2@pcsexch-bknet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2008-09-25 20:47, Horton, Dave wrote:
>
>Actually, my code is rather simple.  I've posted it at the bottom of
>this response.
>
>Here is the main piece of my code:
>
>		case IPT_PACTOLUS_STATE_FORWARD:
>
>
>			/* modify the source ip:port and the dest
>ip:port, 
>			 * recalc checksums 
>			 */
>			udph->source = ptr->new_src_port ;
>			udph->dest = ptr->new_dst_port ;
>			if (udph->check) {
>				u_int32_t newudplen = (*pskb)->len - 
>				  				iph->ihl
>* 4;
>
>				/* calculate checksum of the data
>portion */
>				(*pskb)->csum = csum_partial((char
>*)udph +
>					sizeof(struct udphdr),
>					newudplen - sizeof(struct
>udphdr), 0);
>				udph->check = 0;
>				udph->check =
>csum_tcpudp_magic(iph->daddr, 
>				    	ptr->new_dst_ip,
>					newudplen, IPPROTO_UDP, 
>					csum_partial((char *)udph,
>					sizeof(struct udphdr),
>(*pskb)->csum));
>			}
>
>			iph->saddr = iph->daddr;
>			iph->daddr = ptr->new_dst_ip;

You cannot change the IP address or L4 port without making conntrack
very unhappy. In the simplest case, you're "just" voiding any state
matching and flow accounting. In the worst case, iph->daddr (and
other fields) does not match skb->nfct->....->daddr (respectively)
anymore and cosmic rays could catalyze up, er, undefined behavior
could arise.
