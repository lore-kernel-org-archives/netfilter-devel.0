From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] iptables: Add autoreconf step in INSTALL document.
Date: Thu, 23 Jul 2009 17:47:36 +0200 (CEST)
Message-ID: <alpine.LSU.2.00.0907231745340.26578@fbirervta.pbzchgretzou.qr>
References: <4A686507.7010403@gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Saikiran Madugula <hummerbliss@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39690 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753117AbZGWPri (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jul 2009 11:47:38 -0400
In-Reply-To: <4A686507.7010403@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Thursday 2009-07-23 15:26, Saikiran Madugula wrote:

>Add autoreconf step in INSTALL document to clarify that one has
>to do autoreconf before they can do any ./configure.

The INSTALL document is written for users of the tarball, which has the 
'configure' script present already.
Developers know what they have to run. (That is to say, I would claim 
that other software projects don't tell you to 
autoreconf/autogen.sh/bootstraep.sh either.)
So this is not needed IMO.

>@@ -3,6 +3,7 @@ Installation instructions for iptables
> 
> iptables uses the well-known configure(autotools) infrastructure.
> 
>+	$ autoreconf -vfi
> 	$ ./configure
> 	$ make
> 	# make install
>-- 
