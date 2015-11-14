From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: Re: [PATCH v4] libmnl: Drop the EXPORT_SYMBOL() tags
Date: Sat, 14 Nov 2015 07:45:44 +0700
Message-ID: <CAMQP0snn7nt=iK6Um4doYFPSn1ffTDtUOKi8NBjp=ZCE58EXQw@mail.gmail.com>
References: <20151029190717.GE5154@vapier.lan>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: 20151006012711.GA5372@oxygen.gentoo.org,
	netfilter-devel@vger.kernel.org,
	Neutron Soutmun <neo.neutron@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f169.google.com ([209.85.223.169]:34092 "EHLO
	mail-io0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751085AbbKNApp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Nov 2015 19:45:45 -0500
Received: by ioir85 with SMTP id r85so73146312ioi.1
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Nov 2015 16:45:44 -0800 (PST)
In-Reply-To: <20151029190717.GE5154@vapier.lan>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Oct 30, 2015 at 2:07 AM, Mike Frysinger <vapier@gentoo.org> wrote:
> Neutron Soutmun wrote:
>> * libmnl using an export map (-Wl,--version-script=),
>>  hence, no need to explicitly use the EXPORT_SYMBOL() tags.
>
> this isn't entirely accurate.  the use of hidden visibility allows for
> optimizations (e.g. bypassing the PLT).  export maps merely control the
> final visibility of the symbols at link time ... gcc is forced to assume
> every function call otherwise is still globally visible (exported).
>
> it doesn't make a big difference in the libmnl case as there aren't any
> real internal-only symbols, but in larger libraries, this sort of change
> increases code size and runtime overhead.
>
> this is why libraries take a different approach: set default visibility
> to hidden and then update the header with a macro like EXPORT.  there is
> only one file to declare the prototypes and the visibility markings are
> right there.  no need for EXPORT_SYMBOL() lines.  the export map is only
> really for toolchains that lack visibility support.

Thanks to point to this, it really make sense.

> something as simple as the patch below
> -mike

The initial problem for my proposed patch is the incompatible of
symbols visibility in gcc and clang
which libmnl is failed to build from source in clang and it's the one
of another approaches that pass the build in both gcc and clang.

I'll test your patch with clang and back to you ASAP.

Best regards,
Neutron Soutmun
