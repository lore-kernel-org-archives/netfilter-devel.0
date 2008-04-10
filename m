From: Anton <anton.vazir@gmail.com>
Subject: Re: SVN ULOG2
Date: Thu, 10 Apr 2008 17:16:42 +0500
Message-ID: <200804101716.42876.anton.vazir@gmail.com>
References: <200804091520.28617.anton.vazir@gmail.com> <c4b050a10804100355i2fafe654w8d33ef52eb0af71b@mail.gmail.com> <52708.62.160.220.138.1207825228.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Eric Leblond" <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:33383 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755026AbYDJMQo (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Apr 2008 08:16:44 -0400
In-Reply-To: <52708.62.160.220.138.1207825228.squirrel@mail.inl.fr>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

:) Looks like I'm missing something.
Naming ulogd2_ct makes it failing initializing in the 
beginning. 

Thu Apr 10 21:58:59 2008 <1> ulogd.c:705 assigning 
`orig.ip.daddr.str(?)' as source for PGSQL(orig.ip.dadd
r.str)
Thu Apr 10 21:58:59 2008 <7> ulogd.c:699 cannot find key 
`orig.ip.protocol' in stack
Thu Apr 10 21:58:59 2008 <1> ulogd.c:831 destroying stack
Thu Apr 10 21:58:59 2008 <8> ulogd.c:1084 not even a single 
working plugin stack

But - The view - ulog - it consist all of the keys which 
ulogd uses while initializing. But it consists the key 
mac.saddr.str - and here I can't get what's wrong there . 
In the code it seems key is returned as in other modules. 

static struct ulogd_key mac2str_keys[] = {
        {
                .type = ULOGD_RET_STRING,
                .flags = ULOGD_RETF_FREE,
                .name = "mac.saddr.str",
        },
};


Any ideas? ;)




On Thursday 10 April 2008 16:00, Eric Leblond wrote:
> Hello,
>
> > In the case when "ulog2" instead "ulog" in the config -
> > it fails even sooner. See output below... I noticed
> > that there is no table ulog, but since it 's written so
> > in sample config file, and there is a view, named
> > "ulog" in the DB schema - I supposed that should be so.
> > The "timestamp" row it's failing - passed normally when
> > "ulog" table is used.
>
> I wrote ulogd2_ct and not ulog2 ;)
>
> The table argument contains the list of fields that will
> be needed as INPUT key. In the SQL schema ulog and ulog2
> are for packet based logging. The flow based logging
> table is ulog2_ct.
>
> >> Ok, it seems you've pointed to the wrong 'table'
> >> option. You should not point to ulog but to ulog2_ct.
>
> BR,
> --
> Eric Leblond
> INL : http://www.inl.fr
> NuFW, Now User Filtering Works (http://www.nufw.org)
