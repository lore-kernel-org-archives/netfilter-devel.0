From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Nat+Iptables+Tcp Keepalive Problem
Date: Thu, 4 Jun 2009 18:35:28 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.0906041830560.16487@blackhole.kfki.hu>
References: <4A27C999.3000609@gmail.com> <alpine.DEB.2.00.0906041656220.16139@blackhole.kfki.hu> <4A27EE13.5000303@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Emiliano Romero <emilianoromero@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:53613 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753036AbZFDQf1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Jun 2009 12:35:27 -0400
In-Reply-To: <4A27EE13.5000303@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 4 Jun 2009, Emiliano Romero wrote:

> Jozsef Kadlecsik escribi?:
> > The TCP keepalived packet in the output above is invalid: it's sequence
> > number is wrong.
> 
> Thanks for your reply Jozsef. After your reply I look at RFC 1122, It say:
> "Some TCP implementations, however, have included a keep-alive mechanism.  To
> confirm that an idle connection is still active, these implementations send a
> probe segment designed to elicit a response from the peer TCP.  Such a segment
> generally contains SEG.SEQ = SND.NXT-1"
> ..."so that this SEG.SEQ will be outside the window.  Therefore, the probe
> causes the receiver to return an acknowledgment segment"

So the packet is intentionally outside of the window :-).
 
> When I try with a linux box sending TCP KA, I see that this sets the ACK flag
> on TCP KeepAlive and that works correctly. I think that my remote equipments
> (GPRS Modems) are making TCP KA is the wrong way. Or maybe the GPRS Service
> Provider are touching my packets.

On which device did you capture the packets? 

The best would be to capture at both sides, i.e. real sender and receiver. 
Thus one can make sure whether any device between modified packets or not.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
