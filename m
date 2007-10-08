From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: PATCH: "invalid SYNIN=" - a patch and a question
Date: Mon, 8 Oct 2007 16:01:02 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0710081559450.7995@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0709261414200.676@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031420130.5307@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710031545320.31528@blackhole.kfki.hu> <4704812C.8080001@trash.net>
 <Pine.LNX.4.64.0710040926320.1587@blackhole.kfki.hu> <47049D5B.8050001@trash.net>
 <Pine.LNX.4.64.0710041018180.1677@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710052151180.11803@bizon.gios.gov.pl>
 <Pine.LNX.4.64.0710081117270.6987@blackhole.kfki.hu>
 <Pine.LNX.4.64.0710081556570.30123@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1.kfki.hu ([148.6.0.26]:41803 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751863AbXJHOBj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Oct 2007 10:01:39 -0400
In-Reply-To: <Pine.LNX.4.64.0710081556570.30123@bizon.gios.gov.pl>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Mon, 8 Oct 2007, Krzysztof Oledzki wrote:

> > It seems to me conntack is just right.
> 
> So? This bug is in Linux IP stack, as it should not reopen this port or reopen
> using a different SEQ, right? It seems I should go to a different ML. :|

What is the exact kernel version of this machine? Do you have got any 
kernel patches which might touch the IP stack installed?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
