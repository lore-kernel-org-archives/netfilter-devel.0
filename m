From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: TCP connection stalls under 2.6.24.7
Date: Fri, 4 Jul 2008 23:04:34 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0807042303090.4142@blackhole.kfki.hu>
References: <47EA0DAB.7080205@securenet.de> <Pine.LNX.4.64.0803261941460.1905@blackhole.kfki.hu>
 <47F08A52.9070802@securenet.de> <200807041654.15591.thomas.jarosch@intra2net.com>
 <Pine.LNX.4.64.0807042251500.4142@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Patrick McHardy <kaber@trash.net>,
	Sven Riedel <sr@securenet.de>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:52988 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752314AbYGDVEg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 4 Jul 2008 17:04:36 -0400
In-Reply-To: <Pine.LNX.4.64.0807042251500.4142@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, 4 Jul 2008, Jozsef Kadlecsik wrote:

> Have you got SACK enabled? If yes, try to disable it: TCP connection 
> tracking has got some trouble with SACK support. :-(

s/has/had/ as we are speaking of 2.6.24.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
