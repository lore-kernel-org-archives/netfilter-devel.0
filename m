From: Sam Liddicott <sam@liddicott.com>
Subject: Re: Patches to xtables-addons xt_quota2
Date: Fri, 10 Jan 2014 17:12:59 +0000
Message-ID: <CAOj-5WB2LwFgaF_4m6=NyBygXWE-6bfdjqXcoQSWNMV1326gnA@mail.gmail.com>
References: <CAOj-5WAsU-WxdKbP1ijmhRGAO=u204ZyGM5PZNcrsJoOB1hsug@mail.gmail.com>
	<alpine.LSU.2.11.1401091004570.32765@nerf08.vanv.qr>
	<CAOj-5WApVv8Q8BOzHewhoWJ_H=1EA6GwUUsQEqR-kwvB6iMpMg@mail.gmail.com>
	<alpine.LSU.2.11.1401101744130.12831@nerf08.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qe0-f48.google.com ([209.85.128.48]:46839 "EHLO
	mail-qe0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751620AbaAJRNB (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 12:13:01 -0500
Received: by mail-qe0-f48.google.com with SMTP id k5so3551846qej.35
        for <netfilter-devel@vger.kernel.org>; Fri, 10 Jan 2014 09:12:59 -0800 (PST)
In-Reply-To: <alpine.LSU.2.11.1401101744130.12831@nerf08.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 10, 2014 at 4:44 PM, Jan Engelhardt <jengelh@inai.de> wrote:
> On Thursday 2014-01-09 14:35, Sam Liddicott wrote:
>
>>True, it doesn't fix all problems. I don't mind if you strip that part
>>before applying.
>
> Something better, I let you respin #3 :)
>

OK, I will... I didn't like fixed block reading anyway. I'll see if
there is a normal nice way for "stdio" parsing in the kernel or make a
basic one.

Sam
