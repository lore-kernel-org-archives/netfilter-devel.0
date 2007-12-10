From: "Luca Tettamanti" <kronos.it@gmail.com>
Subject: Re: [BUG?] ip6tables: 32bit userspace doesn't work with 64bit kernel
Date: Mon, 10 Dec 2007 14:09:31 +0100
Message-ID: <68676e00712100509q1fcbf42dx6bcb46e95467ac91@mail.gmail.com>
References: <20071208223737.GA8885@dreamland.darkstar.lan>
	 <475C1425.7070608@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from wa-out-1112.google.com ([209.85.146.182]:59682 "EHLO
	wa-out-1112.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126AbXLJNJb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 10 Dec 2007 08:09:31 -0500
Received: by wa-out-1112.google.com with SMTP id v27so3343145wah
        for <netfilter-devel@vger.kernel.org>; Mon, 10 Dec 2007 05:09:31 -0800 (PST)
In-Reply-To: <475C1425.7070608@trash.net>
Content-Disposition: inline
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Dec 9, 2007 5:13 PM, Patrick McHardy <kaber@trash.net> wrote:
> Luca Tettamanti wrote:
> > Hello,
> > I just found out that 32bit (x86) ip6tables does not work with a 64bit
> > kernel. I'm currenly using 2.6.24-rc4-g94545bad, but the structures
> > involved haven't been touched recently.
> >
> > Before you read on: I see that IPv6 code is missing compat* stuff, so is
> > this configuration supported?
>
> Not yet, thanks for pointing this out, I completely forgot
> about that :) I'll put it on my todo list, with some luck
> I can still finish it in time for the 2.6.25 merge window.

Ok, feel free to throw patches this way for testing ;-)

Luca
