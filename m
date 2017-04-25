From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next 2/3] netfilter: nf_log: don't call synchronize_rcu
 in nf_log_unset
Date: Tue, 25 Apr 2017 14:33:20 +0800
Message-ID: <CAML_gOeVo1cgPXtR4RPJHMHmgTL7d6qJ47iTF2JxoU0qifKr2g@mail.gmail.com>
References: <20170424133741.2707-1-fw@strlen.de> <20170424133741.2707-3-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f68.google.com ([209.85.213.68]:36489 "EHLO
        mail-vk0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S980849AbdDYGdV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Apr 2017 02:33:21 -0400
Received: by mail-vk0-f68.google.com with SMTP id q78so7301524vke.3
        for <netfilter-devel@vger.kernel.org>; Mon, 24 Apr 2017 23:33:21 -0700 (PDT)
In-Reply-To: <20170424133741.2707-3-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

2017-04-24 21:37 GMT+08:00 Florian Westphal <fw@strlen.de>:
> nf_log_unregister() (which is what gets called in the logger backends
> module exit paths) does a (required, module is removed) synchronize_rcu().
>
> But nf_log_unset() is only called from pernet exit handlers. It doesn't
> free any memory so there appears to be no need to call synchronize_rcu.

If I did not miss something, maybe there's an exception here, in
the nfnetlink_log.ko's module exit routine, nf_log_unregister
is invoked before unregister_pernet_subsys, i.e. _log_unregister
will be done before _log_unset.

So removing the synchronize_rcu in _log_unset will become unsafe
when uninstalling the nfnetlink_log.ko:

static void __exit nfnetlink_log_fini(void)
{
    nf_log_unregister(&nfulnl_logger);  --> synchronize_rcu here.
    nfnetlink_subsys_unregister(&nfulnl_subsys);
    netlink_unregister_notifier(&nfulnl_rtnl_notifier);
    unregister_pernet_subsys(&nfnl_log_net_ops); --> _log_unset
without synchronize_rcu.
}

So I think after dropping the synchronize_rcu in _log_unset, we
should also put the "nf_log_unregister(&nfulnl_logger);" to the
end, just like other nf_log_X modules do.
