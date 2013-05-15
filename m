From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Suspicious iptables snapshot in NF FTP
Date: Wed, 15 May 2013 23:35:45 +0200 (CEST)
Message-ID: <alpine.DEB.2.00.1305152328330.3805@blackhole.kfki.hu>
References: <alpine.LNX.2.01.1305152256410.8046@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp-in.kfki.hu ([148.6.0.25]:41734 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751446Ab3EOVfs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 May 2013 17:35:48 -0400
In-Reply-To: <alpine.LNX.2.01.1305152256410.8046@nerf07.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, 15 May 2013, Jan Engelhardt wrote:

> A script in conjunction with the openSUSE Build Service has reported 
> that a new version "030513" of iptables, which is due to the 
> new existence of
> 
>  http://ftp.netfilter.org/pub/iptables/iptables-030513.tar.bz2
> 
> This file looks somewhat out of place (were snapshots not in another 
> directory?) and is possible to be flagged up Debian and other distros' 
> "new version update"-type search programs as well.

I think it's the result of a broken script creating the daily snapshots.
I have moved the file out of the public ftp directory, thanks for the 
notification.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlecsik.jozsef@wigner.mta.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : Wigner Research Centre for Physics, Hungarian Academy of Sciences
          H-1525 Budapest 114, POB. 49, Hungary
