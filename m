From: Anton <anton.vazir@gmail.com>
Subject: Re: SVN ULOG2
Date: Thu, 10 Apr 2008 18:03:40 +0500
Message-ID: <200804101803.40843.anton.vazir@gmail.com>
References: <200804091520.28617.anton.vazir@gmail.com> <200804101716.42876.anton.vazir@gmail.com> <53257.62.160.220.138.1207830841.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Eric Leblond" <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:52380 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755546AbYDJNDo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 09:03:44 -0400
In-Reply-To: <53257.62.160.220.138.1207830841.squirrel@mail.inl.fr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Seems all got simplier :) After an hour trying to define
mac.saddr.str in different places in sources (say dances 
with tambourine) i more carefully looked at the config 
file, and just addition of the following in the ulogd.conf 
resolved the issue :)

plugin="/usr/local/lib/ulogd/ulogd_filter_MAC2STR.so"
stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,mac2str1:MAC2STR,pgsql1:PGSQL

All the rest is the original sample of ulogd.conf

Maybe it's worth to add this line into a sample ulogd.conf 
to avoid stupid questions from newbees like me :)

Thanks so much for help Eric!
Regards to all!
Anton.

On Thursday 10 April 2008 17:34, Eric Leblond wrote:
> Hello,
>
> > :) Looks like I'm missing something.
> >
> > Naming ulogd2_ct makes it failing initializing in the
> > beginning.
> >
> >
> > Any ideas? ;)
>
> It seems you've got the wrong stack. To define the
> correct stack, you may find this link useful :
> http://software.inl.fr/trac/wiki/ulogd2/user
>
> For NFCT based logging to Postgres, the following stack
> should work : stack=ct1:NFCT,ip2str1:IP2STR,pgsql:PGSQL
>
> BR,
> --
> Eric Leblond
> INL : http://www.inl.fr
> NuFW, Now User Filtering Works (http://www.nufw.org)
