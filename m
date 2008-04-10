From: "Anton VG" <anton.vazir@gmail.com>
Subject: Re: SVN ULOG2
Date: Thu, 10 Apr 2008 15:55:15 +0500
Message-ID: <c4b050a10804100355i2fafe654w8d33ef52eb0af71b@mail.gmail.com>
References: <200804091520.28617.anton.vazir@gmail.com>
	 <47FCA1F6.2000204@netfilter.org>
	 <200804091624.19125.anton.vazir@gmail.com>
	 <c4b050a10804100119m488a00a1hee1c3a2768ea736d@mail.gmail.com>
	 <51855.62.160.220.138.1207819513.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Eric Leblond" <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.184]:16159 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754154AbYDJKzQ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 06:55:16 -0400
Received: by nf-out-0910.google.com with SMTP id g13so1335790nfb.21
        for <netfilter-devel@vger.kernel.org>; Thu, 10 Apr 2008 03:55:15 -0700 (PDT)
In-Reply-To: <51855.62.160.220.138.1207819513.squirrel@mail.inl.fr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

In the case when "ulog2" instead "ulog" in the config - it fails even
sooner. See output below... I noticed that there is no table ulog, but
since it 's written so in sample config file, and there is a view,
named "ulog" in the DB schema - I supposed that should be so. The
"timestamp" row it's failing - passed normally when "ulog" table is
used.

Thu Apr 10 20:39:54 2008 <1> ulogd.c:705 assigning `ip.csum(?)' as
source for PGSQL(ip.csum)
Thu Apr 10 20:39:54 2008 <1> ulogd.c:605 base1(BASE)
Thu Apr 10 20:39:54 2008 <1> ulogd.c:705 assigning `ip.id(?)' as
source for PGSQL(ip.id)
Thu Apr 10 20:39:54 2008 <1> ulogd.c:605 base1(BASE)
Thu Apr 10 20:39:54 2008 <1> ulogd.c:705 assigning `ip.fragoff(?)' as
source for PGSQL(ip.fragoff)
Thu Apr 10 20:39:54 2008 <7> ulogd.c:699 cannot find key `timestamp' in stack
Thu Apr 10 20:39:54 2008 <1> ulogd.c:831 destroying stack
Thu Apr 10 20:39:54 2008 <8> ulogd.c:1084 not even a single working plugin stack

Regards,
Anton.

2008/4/10, Eric Leblond <eric@inl.fr>:
> Hello,
>
>
>  > One more issue (though not sure is I did not miss something in
>  > configuration)
>  >
>  > Trying to do Postgresql logging. Postgres 8.3
>  > This is the entry, ulogd fails initializing on.
>  >
>  > Thu Apr 10 18:02:26 2008 <7> ulogd.c:699 cannot find key
>  > `mac.saddr.str' in stack
>  > Thu Apr 10 18:02:26 2008 <1> ulogd.c:831 destroying stack
>  > Thu Apr 10 18:02:26 2008 <8> ulogd.c:1084 not even a single working plugin
>  > stack
>
>
> Ok, it seems you've pointed to the wrong 'table' option. You should not
>  point to ulog but to ulog2_ct.
>  But you will next have to set 'procedure' to a hmmm not yet written in
>  Postgres function ...
>
>  I do not have the time to do it now but I think you can easily write one
>  based on the INSERT_CT function in mysql schema.
>
>  BR,
>
> --
>  Eric Leblond
>  INL : http://www.inl.fr
>  NuFW, Now User Filtering Works (http://www.nufw.org)
>
>
