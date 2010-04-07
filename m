From: Andrew Watts <akwatts@ymail.com>
Subject: Re: Accessing sk_buf
Date: Wed, 7 Apr 2010 05:35:12 -0700 (PDT)
Message-ID: <28842.10875.qm@web111014.mail.gq1.yahoo.com>
References: <alpine.LSU.2.01.1004061255130.16293@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from web111014.mail.gq1.yahoo.com ([67.195.15.206]:40515 "HELO
	web111014.mail.gq1.yahoo.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with SMTP id S1751617Ab0DGMfP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Apr 2010 08:35:15 -0400
In-Reply-To: <alpine.LSU.2.01.1004061255130.16293@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--- On Tue, 4/6/10, Jan Engelhardt <jengelh@medozas.de>
wrote:

> On Monday 2010-04-05 12:10, Andrew
> Watts wrote:
> 
> >Dear list:
> >
> >I am writing a "bump" message for a previous post of
> mine. I would like
> >suggestions or advice on how to go about accessing
> packet skbuf->sk
> >fields (inodes, for example), in userspace via NFQUEUE.
> My read is
> >that this is currently not possible as these are not
> exported.
> >
> >Has anyone played with patches that achieve this? Any
> suggestions on
> >where to look?
> 
> There is a bug report at 
> http://bugzilla.netfilter.org/show_bug.cgi?id=600 where
> I posted a 
> patch, but it has not seen acceptance yet. May need to push
> harder.
> 

That is exactly what I needed to see, in terms of suggested code.
I can easily tweak this to meet my needs (I think) - much
appreciated. 

I will also be tracking that part of netfilter to see if your patch
gets mainlined going forward.

Thanks.
~Andy


      
