From: Yang Yang <kormny@gmail.com>
Subject: Re: How to fix 'undefined symbol: ip6tc_ops'
Date: Mon, 18 Jun 2012 14:45:14 +0800
Message-ID: <CAMOvP7ec28fqR+H_tWUnhf3zDePLg6sQ1ajh+aLQPSYK-oVODw@mail.gmail.com>
References: <CAMOvP7fEFDofXnWHMnOtCV+1hB4H=rxJo6BYE5PtndK+Uc1KFg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vc0-f174.google.com ([209.85.220.174]:62403 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752281Ab2FRGpR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Jun 2012 02:45:17 -0400
Received: by vcbf11 with SMTP id f11so2485044vcb.19
        for <netfilter-devel@vger.kernel.org>; Sun, 17 Jun 2012 23:45:14 -0700 (PDT)
In-Reply-To: <CAMOvP7fEFDofXnWHMnOtCV+1hB4H=rxJo6BYE5PtndK+Uc1KFg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

2012/6/18 Yang Yang <kormny@gmail.com>:
> Hi,
>
> Actually I've posted this question to 'netfilter@vger.kernel.org', but
> I didn't get an answer. So I'm looking for help here.
>
> I just have cross compiled iptables for my ARM-Linux board, but when I
> tried run it, the error 'iptables: symbol lookup error: iptables:
> undefined symbol: ip6tc_ops' occurred.
>
> I have no idea how to fix it, is there anyone can help?
>
> here're the details:
>
> s3c6410 (ARM11)
> Linux-3.0.1
> iptables-1.4.14
> commad: iptables
> Error : iptables: symbol lookup error: iptables: undefined symbol: ip6tc_ops
>
> Thanks.
> --------
> Regards,
> Yang Yang

This time I've tried to use iptables-1.4.3.1, and it works. I believe
there is some bug in some latest version of iptables. (
iptables-1.4.13 didn't work either )

--------
Regards,
Yang Yang
