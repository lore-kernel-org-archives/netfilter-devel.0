From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: helpers register for a specific port, but work anyway
Date: Wed, 27 Feb 2008 15:36:31 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0802271534551.12047@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0802271528310.15321@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:44060 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751595AbYB0Ogf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 09:36:35 -0500
In-Reply-To: <Pine.LNX.4.64.0802271528310.15321@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Wed, 27 Feb 2008, Jan Engelhardt wrote:

> in nf_conntrack_ftp.c for example we find
> 
>              ftp[i][j].tuple.src.u.tcp.port = htons(ports[i]);
> 
> assuming the user does not specify any ports on modprobe, the default 
> port list defaults to {21}, so ftp[0][x].tuple.src will contain port 21. 
> But even ftp connections to non-21 ports are inspected for PORT 
> commands. 

Why do you think so? Ports not specified as FTP command ports are not 
parsed.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
