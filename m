From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Thu, 4 Oct 2007 09:52:04 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710040926320.1587@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu> <4704812C.8080001@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Krzysztof Oledzki <ole@ans.pl>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:39985 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753654AbXJDHwH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 03:52:07 -0400
In-Reply-To: <4704812C.8080001@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

On Thu, 4 Oct 2007, Patrick McHardy wrote:

> Jozsef Kadlecsik wrote:
> > I think the code segment is correct. However, the end of the segment 
> > is miscalculated by segment_seq_plus_len because the offset added to 
> > 'dataoff' by the get_l4proto function of IPv4/IPv6 is not taken into 
> > account. Please check whether the patch below fixes it:
> 
> Actually that offset should always be zero for anything but packets
> encapsulated within ICMP, which don't pass though TCP conntrack.

Here we calculate the sequence number of the last octet in the packet from 
the actual data length of the skbuff, so by the 'dataoff' argument of 
segment_seq_plus_len we must pass the length of the IP(v4|6) header. But 
the 'dataoff' parameter supplied by the nf_conntrack core is larger by 
skb_network_offset(skb) therefore 'dataoff' must be decremented by it 
before passing to segment_seq_plus_len.
 
Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
