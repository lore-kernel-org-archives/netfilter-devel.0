From: "Eric Leblond" <eric@inl.fr>
Subject: Re: SVN ULOG2
Date: Thu, 10 Apr 2008 11:25:13 +0200 (CEST)
Message-ID: <51855.62.160.220.138.1207819513.squirrel@mail.inl.fr>
References: <200804091520.28617.anton.vazir@gmail.com>
    <47FCA1F6.2000204@netfilter.org>
    <200804091624.19125.anton.vazir@gmail.com>
    <c4b050a10804100119m488a00a1hee1c3a2768ea736d@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: "Pablo Neira Ayuso" <pablo@netfilter.org>,
	"Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Anton VG" <anton.vazir@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from fydelkass.inl.fr ([195.101.59.116]:53053 "EHLO fydelkass.inl.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752480AbYDJJZS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 05:25:18 -0400
In-Reply-To: <c4b050a10804100119m488a00a1hee1c3a2768ea736d@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

> One more issue (though not sure is I did not miss something in
> configuration)
>
> Trying to do Postgresql logging. Postgres 8.3
> This is the entry, ulogd fails initializing on.
>
> Thu Apr 10 18:02:26 2008 <7> ulogd.c:699 cannot find key
> `mac.saddr.str' in stack
> Thu Apr 10 18:02:26 2008 <1> ulogd.c:831 destroying stack
> Thu Apr 10 18:02:26 2008 <8> ulogd.c:1084 not even a single working plugin
> stack

Ok, it seems you've pointed to the wrong 'table' option. You should not
point to ulog but to ulog2_ct.
But you will next have to set 'procedure' to a hmmm not yet written in
Postgres function ...

I do not have the time to do it now but I think you can easily write one
based on the INSERT_CT function in mysql schema.

BR,
--
Eric Leblond
INL : http://www.inl.fr
NuFW, Now User Filtering Works (http://www.nufw.org)

