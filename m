From: "Eric Leblond" <eric@inl.fr>
Subject: Re: SVN ULOG2
Date: Thu, 10 Apr 2008 14:34:01 +0200 (CEST)
Message-ID: <53257.62.160.220.138.1207830841.squirrel@mail.inl.fr>
References: <200804091520.28617.anton.vazir@gmail.com>
    <c4b050a10804100355i2fafe654w8d33ef52eb0af71b@mail.gmail.com>
    <52708.62.160.220.138.1207825228.squirrel@mail.inl.fr>
    <200804101716.42876.anton.vazir@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Eric Leblond" <eric@inl.fr>,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Anton" <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:60679 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754662AbYDJMeF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:34:05 -0400
In-Reply-To: <200804101716.42876.anton.vazir@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

> :) Looks like I'm missing something.
> Naming ulogd2_ct makes it failing initializing in the
> beginning.
>
>
> Any ideas? ;)

It seems you've got the wrong stack. To define the correct stack, you may
find this link useful :
http://software.inl.fr/trac/wiki/ulogd2/user

For NFCT based logging to Postgres, the following stack should work :
stack=ct1:NFCT,ip2str1:IP2STR,pgsql:PGSQL

BR,
--
Eric Leblond
INL : http://www.inl.fr
NuFW, Now User Filtering Works (http://www.nufw.org)

