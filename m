From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Patch for ipset/setlist
Date: Sat, 27 Mar 2010 14:53:02 +0100 (CET)
Message-ID: <alpine.DEB.2.00.1003271450400.2792@blackhole.kfki.hu>
References: <d85152341003270459t30d2960cxb71a349b217cef77@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: =?ISO-8859-15?Q?Piotr_Pir=F3g?= <pirogpiotr@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp0.kfki.hu ([148.6.0.25]:39890 "EHLO smtp0.kfki.hu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753311Ab0C0NxH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 27 Mar 2010 09:53:07 -0400
In-Reply-To: <d85152341003270459t30d2960cxb71a349b217cef77@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sat, 27 Mar 2010, Piotr Pir?g wrote:

> This patch adds ??matchall? argument to setlist. By default, setlist
> returns true if packet match to any of it members. With ?matchall
> packet must match to every member of setlist.
> This is my first patch, so sorry if I do something wrong. Comments are welcome.

Could you write an example where it is useful? I can't figure out how 
could it be used.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@mail.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
          H-1525 Budapest 114, POB. 49, Hungary
