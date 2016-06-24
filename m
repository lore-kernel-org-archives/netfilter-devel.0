From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next] netfilter: xt_cpu: no need to check the validity
 of invert flag
Date: Fri, 24 Jun 2016 09:41:08 +0800
Message-ID: <CAML_gOfKArDeqJzvo-WEdA67FAB=uaE3Ax4AZvhDykU=mKGQFA@mail.gmail.com>
References: <1465388607-26771-1-git-send-email-zlpnobody@163.com> <20160623111118.GA2695@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>, netfilter-devel@vger.kernel.org,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f67.google.com ([209.85.213.67]:34550 "EHLO
	mail-vk0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750887AbcFXBlK (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 21:41:10 -0400
Received: by mail-vk0-f67.google.com with SMTP id n127so2701742vkb.1
        for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 18:41:09 -0700 (PDT)
In-Reply-To: <20160623111118.GA2695@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2016-06-23 19:11 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
>> -static int cpu_mt_check(const struct xt_mtchk_param *par)
>> -{
>> -     const struct xt_cpu_info *info = par->matchinfo;
>> -
>> -     if (info->invert & ~1)
>> -             return -EINVAL;
>> -     return 0;
>> -}
>
> This trick is there so we can convert info->invert to info->flags in
> the future without a new revision (given the binary interface did not
> change). I'm not convinced there is much of benefit from getting rid
> of this little extra _check() code that runs from the control plane
> path.
>

Thanks for pointing this out. At my first glace, I think this _check
is tricky and a little ugly,
so I try to remove it and send this patch.

As you said, if we add new flags in the future, for example, we
support a new flag like this
"iptables -A INPUT -m cpu --cpu 0 --flagXXX". When the user use the
new iptables utility
but the kernel is old, currently kernel will reject this request,
because we don't recognize the
"flagXXX".

But apply my patch, kernel will just ignore this unknown flag, this
will confuse the user.
And change a new revision seems unworthy.

So I'd rather not apply this pacth.

Thanks.
