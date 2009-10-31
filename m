From: Luca Pesce <pesce.luca@gmail.com>
Subject: Re: Questions about early_drop()
Date: Sat, 31 Oct 2009 13:50:49 +0100
Message-ID: <4AEC32A9.8090405@gmail.com>
References: <873dce860910310507v756ce39nf68bb102afb28658@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:50006 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757698AbZJaMuy (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 31 Oct 2009 08:50:54 -0400
Received: by bwz27 with SMTP id 27so4543491bwz.21
        for <netfilter-devel@vger.kernel.org>; Sat, 31 Oct 2009 05:50:57 -0700 (PDT)
In-Reply-To: <873dce860910310507v756ce39nf68bb102afb28658@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I just realized that point 4 is very lame and wrong, so please skip it, 
consider only the first three questions.
Thanks.

Luca Pesce ha scritto:
> Hi all,
>     today I was looking at early_drop() code in nf_conntrack_core.c, and I came
> up with some questions, due to the fact that I am not such a netfilter expert...
> I am not running the latest kernel:  I am cutting&pasting early_drop()
> of my kernel
> at the end of this mail, note that compared to 2.6.31.x this is quite different.
>
> 1- why does early_drop() increase the ct_general.use count of the ct
> to be dropped
> before calling death_by_timeout(), and then decreases it with nf_ct_put(ct)? Is
> this a way to postpone ct death? What for?
>
> 2- I see that 2.6.31.5 version of early_drop() is more complex: it crosses more
> than one bucket looking for not assured connections to be killed. I like that
> approach, but I was wondering if this is not burning too much CPU when the
> conntrack table is overly saturated persistently (and so when this function is
> called very often)...any experience about that?
> Can I port the whole early_drop() of 2.6.31.5 on my kernel?
>
> 3- on 2.6.31.5 version of early_drop(), there are two added checks
> before killing
> the conntrack:
>
>  if (ct && unlikely(nf_ct_is_dying(ct) ||
> 				   !atomic_inc_not_zero(&ct->ct_general.use)))
> 			ct = NULL;
> 			
> I understand that these are to ensure that the ct is not already dying
> for itself:
> should I add those to early_drop() which I am currently using to avoid races?
>
>
> Thanks for your time,
> Luca
>
>   

