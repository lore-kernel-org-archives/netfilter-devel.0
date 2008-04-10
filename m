From: "Eric Leblond" <eric@inl.fr>
Subject: Re: SVN ULOG2
Date: Thu, 10 Apr 2008 15:09:32 +0200 (CEST)
Message-ID: <53696.62.160.220.138.1207832972.squirrel@mail.inl.fr>
References: <200804091520.28617.anton.vazir@gmail.com>
    <200804101716.42876.anton.vazir@gmail.com>
    <53257.62.160.220.138.1207830841.squirrel@mail.inl.fr>
    <200804101803.40843.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Eric Leblond" <eric@inl.fr>,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Anton" <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:52632 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755061AbYDJNJf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 09:09:35 -0400
In-Reply-To: <200804101803.40843.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

> plugin="/usr/local/lib/ulogd/ulogd_filter_MAC2STR.so"
> stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,mac2str1:MAC2STR,pgsql1:PGSQL
>
> All the rest is the original sample of ulogd.conf
>
> Maybe it's worth to add this line into a sample ulogd.conf
> to avoid stupid questions from newbees like me :)

Just send to the ML a patch to ulogd.conf.in with these modifications ;)

>
> Thanks so much for help Eric!

You're welcome.

BR,
--
Eric Leblond
INL : http://www.inl.fr
NuFW, Now User Filtering Works (http://www.nufw.org)

