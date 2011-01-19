From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [patch 0/2] Ipset patches
Date: Wed, 19 Jan 2011 22:59:35 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1101192255590.31954@blackhole.kfki.hu>
References: <20110119202607.532407993@eitzenberger.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: holger@eitzenberger.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:57324 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753109Ab1ASV7g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jan 2011 16:59:36 -0500
In-Reply-To: <20110119202607.532407993@eitzenberger.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Holger,

On Wed, 19 Jan 2011, holger@eitzenberger.org wrote:

> what follows are two small patches which remove unneeded argv[]
> loops when parsing the ipset commands.  They are in particular no
> change in command line handling.
> 
> The command line handling can still be improved, as e. g.
> 
>  $ ipset -o xml create foo hash:ip
>  $ ipset -s add foo 192.168.1.1
> 
> both work, but the options are just ignored.  And they don't
> make much sense for either 'create' or 'add'.
> 
> Also we should consider to make the argument handling a little
> more strict, as e. g.
> 
>  $ ipset -o xml list foo
>  $ ipset list -o xml foo
>  $ ipset list foo -o xml
> 
> all work.  By removing some of those possibilities it should even
> get simpler code wise.

Thank you indeed, after fixing the issues raised by Patrick and Eric, I'll 
work on the userspace part and your patches.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
