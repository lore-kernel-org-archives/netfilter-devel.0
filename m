From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Fri, 12 Oct 2007 16:48:39 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710121611580.15832@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710102054120.13087@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710112238010.29814@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710120026240.14889@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710121139240.10132@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:50774 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752317AbXJLOsn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 12 Oct 2007 10:48:43 -0400
In-Reply-To: <Pine.LNX.4.64.0710121139240.10132@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, 12 Oct 2007, Krzysztof Oledzki wrote:

> > Odd, but I could not reproduce it using my local test webserver.
> 
> I think you may test it with wp.pl, it is quite a big portal. No harm will be
> done with little more requests. ;)

All of the machines I have got access are behind firewalls.
 
> > Could you check the patch below?
> 
> Assuming that I did not mispatched my kernel, this patch does not solve
> described problem. :( 

The patch should have been applied on the top of the previous one I sent.

> Do you need more tcpdumps or maybe a "conntrack -o time -E" log?

Could you send me a pcap file captured with '-s 0'? Then I could replay it 
and see what happens.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
