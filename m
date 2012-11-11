From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: FSM for TCP proto
Date: Sun, 11 Nov 2012 18:47:14 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1211111827470.16407@blackhole.kfki.hu>
References: <CACd4Q021-ukEstznTnm-3Jst9_E94R7Q89ohFrs05S2uj5W+Mg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: =?ISO-8859-15?Q?Nicolas_Ma=EEtre?= <nimai@skynet.be>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:59655 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751358Ab2KKRrR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 11 Nov 2012 12:47:17 -0500
In-Reply-To: <CACd4Q021-ukEstznTnm-3Jst9_E94R7Q89ohFrs05S2uj5W+Mg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 11 Nov 2012, Nicolas Ma?tre wrote:

> I've been trying to understand netfilter's connection tracking for TCP.
> 
> The FSM used is a simplified version of the usual TCP FSM, and
> therefore, as I understand it, it does not permit a perfect tracking
> of TCP.

Perfect tracking is not possible, because the packets we see may get lost 
in transit to the destination.
 
> A first question is: why not rely on a better version of the FSM? It
> would maybe imply that the states of both end-hosts should be stored
> but it would also allow a finer-grained tracking of the connection.

Someone should simply come up with a better version.
 
> I assume this is because the firewall doesn't need to be so specific
> about the tracking, but why not? Wouldn't it be better from a security
> viewpoint?
>
> In the same line of thinking, I can see that, for example, at the
> regular connection closing, no check is done on the direction of the
> FIN segments. AFAIK, this would mean that a host could make think the
> firewall that a connection is closed when it is actually sending 2
> times a  FIN segment. A one-liner check would make sure that both FINs
> come from different hosts, why omit this?

That's documented in a comment of the state table. If there's a real 
threat from it, then that one-liner should be added to the code.

> The real question is: am I missing something important that would make
> this kind of things insignificant?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
