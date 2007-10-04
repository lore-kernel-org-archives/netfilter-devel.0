From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Thu, 4 Oct 2007 09:26:26 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710040908060.1587@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710032152430.5307@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.28]:37734 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751942AbXJDH03 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 4 Oct 2007 03:26:29 -0400
In-Reply-To: <Pine.LNX.4.64.0710032152430.5307@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Wed, 3 Oct 2007, Krzysztof Oledzki wrote:

> Does this same error exist in 2.6.22?

Yes, and in earlier releases as well: as far as I see the bug was 
introduced by nf_conntrack.
 
> BTW: what is your opinion about
> net.netfilter.nf_conntrack_tcp_timeout_time_wait?

We already "violate" the RFC. And considering other IP stacks, in order
to avoid all unnecessarily blocked late packets, we should probably set 
the timeout value back to 2*MSL.

By setting it to 1MSL we try to find the proper balance between "not too 
much blocked late packets" and "get rid of conntrack entries as fast as 
possible".

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
