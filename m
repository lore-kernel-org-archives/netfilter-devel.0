From: Richard <tuxbox.guru@gmail.com>
Subject: Re: Netfilter_Bridge parent bridge name in hook
Date: Sat, 28 May 2016 09:11:10 +0100
Message-ID: <CAKQROYX6JZkaSdn_uAWpnhtXVWZ36_YqAYB4MPvzhud7kBa5cg@mail.gmail.com>
References: <CAKQROYVMwycJ-EyWNkHMKpk66a68rTdiCV-tCfyNqW8nspunVg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lf0-f67.google.com ([209.85.215.67]:34370 "EHLO
	mail-lf0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750701AbcE1ILM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 28 May 2016 04:11:12 -0400
Received: by mail-lf0-f67.google.com with SMTP id 65so10380140lfq.1
        for <netfilter-devel@vger.kernel.org>; Sat, 28 May 2016 01:11:11 -0700 (PDT)
In-Reply-To: <CAKQROYVMwycJ-EyWNkHMKpk66a68rTdiCV-tCfyNqW8nspunVg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22 May 2016 at 20:05, Richard <tuxbox.guru@gmail.com> wrote:
> Hi All,
>
> I have a netfilter_bridge hook kernel module working very well, but it
> acts on all bridge interfaces.  Not for a lack of trying to find a
> method to find which will show me the name of the Bridge interface the
> ingress/egress net_devices are a member of.
>
> Below is the hook (boiler plate prototype) - in->name = eth0, which is
> what I need... but I also need to know what bridge eth0 is enslaved
> in.
>
> unsigned int nf_icmp_forward_hook(unsigned int hooknum,
>                                   struct sk_buff* skb,
>                                   const struct net_device* in,
>                                   const struct net_device* out,
>                                   int (*okfn)(struct sk_buff*));
>
>
> How can I get the Bridge name that the IN devices is a member of.
>
> Any pointers would be greatly appreciated.
>
>
> Regards,
> Richard


To answer, (and conclude the question) Thanks for all the help.

    rtnl_lock();
    br_master = netdev_master_upper_dev_get((struct net_device *)in);
    rtnl_unlock();

Richard
