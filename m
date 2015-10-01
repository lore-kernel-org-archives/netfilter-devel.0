From: Neutron Soutmun <neo.neutron@gmail.com>
Subject: Re: [PATCH] libmnl: Failed to build with clang, incompatible
 EXPORT_SYMBOL(x) macro
Date: Thu, 1 Oct 2015 10:15:59 +0700
Message-ID: <CAMQP0snZZifu3bJAsXU6H_GOUXNKpeoT1_rcgyMOj5YT9c+6DQ@mail.gmail.com>
References: <20150925040745.GA433@oxygen>
	<20150930221241.GA14943@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ig0-f170.google.com ([209.85.213.170]:37395 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754976AbbJADQA (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Sep 2015 23:16:00 -0400
Received: by igbni9 with SMTP id ni9so5704284igb.0
        for <netfilter-devel@vger.kernel.org>; Wed, 30 Sep 2015 20:16:00 -0700 (PDT)
In-Reply-To: <20150930221241.GA14943@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Oct 1, 2015 at 5:12 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> We have more libraries using this approach, which resembles kernel
> coding. So we would need to update them all, which is a bit annoying.

Ah, I see. I try to find many approaches to easy fix this but not success.

Refer to [1] which the reporter proposes the patch

== 8< ==

ifeq ($(shell $(CC) --version | grep -c "clang version"),1)
CFLAGS += -fvisibility=default
endif

== 8< ==

I have tested, the symbols exported but I think It will override the
visibility attributes, therefore, I have prepared my proposed patch.

> Though this warning results in a real problem since symbols will not
> be exported.
> Why is clang rejecting this?

I'm not sure. It seems that clang expands the EXPORT_SYMBOL() as
a redefined of it's exported symbol function which is far different from gcc
implementation.

I try to seek more info [2] and see the export.h source [3] but
I have no idea for what's next -_-''

Best regards,
Neutron Soutmun

[1] https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=789480
[2] http://llvm.linuxfoundation.org/index.php/Main_Page
[3] http://lxr.free-electrons.com/source/include/linux/export.h
