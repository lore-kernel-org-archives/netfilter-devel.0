From: Kevin Cernekee <cernekee@gmail.com>
Subject: Re: [PATCH iptables 2/3] android: Don't include conflicting headers
Date: Thu, 2 Jan 2014 17:28:49 -0800
Message-ID: <CAJiQ=7BKtX-XOpKAk_gdQ_Fcgsxq8-+0xHbaGBV6YSHe-=jtGg@mail.gmail.com>
References: <1382813433-20890-1-git-send-email-cernekee@gmail.com>
	<1382813433-20890-3-git-send-email-cernekee@gmail.com>
	<20131105130248.GA29037@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f44.google.com ([209.85.160.44]:56246 "EHLO
	mail-pb0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751886AbaACB2t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Jan 2014 20:28:49 -0500
Received: by mail-pb0-f44.google.com with SMTP id rq2so15050444pbb.31
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Jan 2014 17:28:49 -0800 (PST)
In-Reply-To: <20131105130248.GA29037@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Nov 5, 2013 at 5:02 AM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> Hi Kevin,
>
> On Sat, Oct 26, 2013 at 11:50:32AM -0700, Kevin Cernekee wrote:
>> <netinet/ip.h> and <linux/ip.h> redefine a couple of structs, including
>> iphdr.  Handle this the same way as on glibc, i.e. don't include
>> <linux/ip.h>.
>>
>> This change comes from AOSP.
>
> No major objections to this 1/3 and 2/3, but I don't see this patch
> here:
>
> https://android.googlesource.com/platform/external/iptables/
>
> Please, tell me if it's the right place to look at. Any plan to
> include these patches to AOSP repositories?

1/3 (socklen_t redefinition) is included here:

https://android.googlesource.com/platform/external/iptables/+/master/libiptc/libip4tc.c
https://android.googlesource.com/platform/external/iptables/+/master/libiptc/libip6tc.c

2/3 (conflicting ip.h headers) is included here:

https://android.googlesource.com/platform/external/iptables/+/master/include/libiptc/ipt_kernel_headers.h

For 3/3 (missing TCPOPT_* breaks the TCPOPTSTRIP module) I submitted a
patch to Bionic, and verified that it allows a successful build with
TCPOPTSTRIP enabled:

https://android-review.googlesource.com/#/c/73580/
