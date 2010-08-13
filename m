From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: event callback in netfilter-conntrack
Date: Fri, 13 Aug 2010 20:56:59 +0800
Message-ID: <AANLkTi=2xK_+sWx9pxk3=8AUEY31ZwTvk0h+5WA6VT48@mail.gmail.com>
References: <AANLkTi=QAxRdeh1srRh8Xdz1qS2eJBzxcRfoNot4=GYd@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pete Kay <petedao@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wy0-f174.google.com ([74.125.82.174]:36575 "EHLO
	mail-wy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934285Ab0HMM5U (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 13 Aug 2010 08:57:20 -0400
Received: by wyb32 with SMTP id 32so2601254wyb.19
        for <netfilter-devel@vger.kernel.org>; Fri, 13 Aug 2010 05:57:19 -0700 (PDT)
In-Reply-To: <AANLkTi=QAxRdeh1srRh8Xdz1qS2eJBzxcRfoNot4=GYd@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 13, 2010 at 7:39 PM, Pete Kay <petedao@gmail.com> wrote:
> Hi,
>
> Does anyone know how to obtain the original sport value from struct
> nf_conntrack *ct within the event callback handler?
>
> Any help will be greatly appreciated.
>

>From the tuple of the original direction.

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
