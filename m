From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset v5.0-pre10
Date: Wed, 15 Dec 2010 21:23:30 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1012152121160.5033@blackhole.kfki.hu>
References: <4D08D0A6.4020900@googlemail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Mr Dash Four <mr.dash.four@googlemail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:58269 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755334Ab0LOUXc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Dec 2010 15:23:32 -0500
In-Reply-To: <4D08D0A6.4020900@googlemail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Wed, 15 Dec 2010, Mr Dash Four wrote:

> I've just looked at the code and man pages for the above - it makes some
> interesting reading!
> 
> I have a question though - Would it be possible for me to specify port ranges
> as well - if not at the members level, then at least from the command line?
> 
> For example, with the current setup if I want to include 'low' ports in a set,
> then I have to run a separate script with a 'count' value from 1 to 1024 and
> execute 1024 different 'ipset -A' statements to include that particular port
> into the set. The situation is much worse if I am dealing with high-ports -
> for obvious reasons.
> 
> Would it be possible to be able to specify port ranges (say, '1-1024') in a
> similar fashion as it is currently done with ip address ranges?

I don't completely understand you: the bitmap:port type already supports 
adding/deleting port ranges. Could you write a full example?

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
