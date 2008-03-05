From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: [PATCH 17/24] Remove support for compilation of conditional
 extensions
Date: Wed, 5 Mar 2008 10:14:23 +0100 (CET)
Message-ID: <Pine.LNX.4.64.0803050958520.23270@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0803040519150.7660@fbirervta.pbzchgretzou.qr>
 <47CD6296.90303@trash.net> <Pine.LNX.4.64.0803041630440.7660@fbirervta.pbzchgretzou.qr>
 <Pine.LNX.4.64.0803041706280.7660@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp2.kfki.hu ([148.6.0.28]:33057 "EHLO smtp2.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756861AbYCEJO0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Mar 2008 04:14:26 -0500
In-Reply-To: <Pine.LNX.4.64.0803041706280.7660@fbirervta.pbzchgretzou.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jan,

On Tue, 4 Mar 2008, Jan Engelhardt wrote:

> Jozsef, Massimiliano: Feel free to either (a) get xt_condition and 
> xt_ipset into the kernel, then can readd to xtables or (b) get 
> xt_condition and xt_ipset into xtables-addons.

I still do not want stubbornly (i.e. foolisly :-) to submit ipset into the 
kernel so option b) remains. But as nfset (ipset-ng) is under the way and 
I do like to submit it, so b) will be "transformed" hopefully to a) in a 
short time. 

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
