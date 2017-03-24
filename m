From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf] netfilter: invoke synchronize_rcu after set the _hook_
 to NULL
Date: Sat, 25 Mar 2017 07:55:53 +0800
Message-ID: <CAML_gOdzYgk5tvZ-3+FgMkT2npoyiKfEq8rR=ynof+9MszWd1w@mail.gmail.com>
References: <1490015030-16403-1-git-send-email-zlpnobody@163.com>
 <20170324121707.GA2764@salvia> <CAML_gOeOE_TSJb2hsNoGBopF_-kxdj3n4c4nzge9qR0q52wpYA@mail.gmail.com>
 <20170324184516.GA2388@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f49.google.com ([209.85.213.49]:35937 "EHLO
        mail-vk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753714AbdCXX4Q (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 24 Mar 2017 19:56:16 -0400
Received: by mail-vk0-f49.google.com with SMTP id s68so5199468vke.3
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Mar 2017 16:55:54 -0700 (PDT)
In-Reply-To: <20170324184516.GA2388@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-03-25 2:45 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
> I think we can get this smaller: it should be possible to avoid this
> synchronize_rcu() call from nf_conntrack_{register,unregister}_notifier().
> These two are called from ctnetlink netns path, this patch already
> adds a synchronize_rcu() spot to ctnetlink module removal which is
> where the event callback can vanish.
>
> You can just add a comment there so we don't forget about this, eg.
>
> @@ -290,6 +290,7 @@  void nf_conntrack_unregister_notifier(struct net
> *net,
>         BUG_ON(notify != new);
>         RCU_INIT_POINTER(net->ct.nf_conntrack_event_cb, NULL);
>         mutex_unlock(&nf_ct_ecache_mutex);
> +       /* synchronize_rcu() is called from ctnetlink. */
>  }
>
> What do you think?

Right, this can avoid two useless synchronize_rcu() invocations when
deleting netns, I will send V2.

Thanks Pablo.
