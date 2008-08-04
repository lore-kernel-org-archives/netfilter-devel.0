From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: rfc: reject use of drop in nat table
Date: Mon, 4 Aug 2008 20:55:32 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0808042050300.7375@blackhole.kfki.hu>
References: <alpine.LNX.1.10.0808041252270.27953@fbirervta.pbzchgretzou.qr>
 <489734F1.8040808@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.26]:44386 "EHLO smtp1.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759789AbYHDSzg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 4 Aug 2008 14:55:36 -0400
In-Reply-To: <489734F1.8040808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 4 Aug 2008, Patrick McHardy wrote:

> Jan Engelhardt wrote:
> > 
> > This just happened to be within my thoughts. Comments, declinations?
> 
> Well, first thought is the usual fear of breaking setups.
> 
> But I do agree that this makes sense, we've had a number
> of "bugreports" over the years from people how tried to
> do filtering in the nat table and didn't realize it only
> sees the first packet of a connection.
> 
> Not sure - anyone else with an opinion? :)

Instead of the line

+                       exit_error(OTHER_PROBLEM, "The nat table is not for filtering");

the next one would probably be little bit more user friendly:

+                       fprintf(stderr, "The nat table is not for filtering, next iptables release won't support it at all. Fix your setup.\n");

And in the next release it could be changed to 'exit_error'.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
