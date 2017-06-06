From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH nf-next RFC 0/5] netfilter: add net namespace support for cthelper
Date: Tue, 6 Jun 2017 12:15:18 +0800
Message-ID: <CAML_gOftcBu-rkgRQd7TA2yFKTdKVSzH7J4oOfoepmGB+d68xQ@mail.gmail.com>
References: <1496589909-56730-1-git-send-email-zlpnobody@163.com>
 <20170604160753.GA843@breakpoint.cc> <CAML_gOf3dW1kVpyObPZoHWSb44DX3w6vhsWXq11xwFU2pFnvFA@mail.gmail.com>
 <20170606000448.GA2608@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Cc: Florian Westphal <fw@strlen.de>, Liping Zhang <zlpnobody@163.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f172.google.com ([209.85.217.172]:36067 "EHLO
        mail-ua0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750722AbdFFEPT (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 6 Jun 2017 00:15:19 -0400
Received: by mail-ua0-f172.google.com with SMTP id h39so32573178uaa.3
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jun 2017 21:15:19 -0700 (PDT)
In-Reply-To: <20170606000448.GA2608@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

2017-06-06 8:04 GMT+08:00 Pablo Neira Ayuso <pablo@netfilter.org>:
[...]
>> I remembered Pablo told me that the ct helpers "is probably one of
>> the remaining subsystems not having netns support", when I sent
>> patches to fix other issues.
>>
>> So I try to accomplish the netns support for ct helpers.
>> (see https://patchwork.ozlabs.org/patch/740692/).
>
> I was referring to cthelper infrastructure, right? So you add
> possible_net to struct nfnl_cthelper?

Do you mean that we only need to support netns for these user
ct helpers? For these kernel built-in ct helpers, we should keep
them unchanged.

So for __nf_conntrack_helper_find, only when the
NF_CT_HELPER_F_USERSPACE is set, we should check the
netns is equal or not, like this:

static bool
nf_ct_helper_net_eq(struct nf_conntrack_helper *helper, struct net *net)
{
    struct nfnl_cthelper *nlhelper;

    if (!(helper->flags & NF_CT_HELPER_F_USERSPACE))
        return true;

    nlhelper = container_of(helper, struct nfnl_cthelper, helper);
    return net_eq(net, read_pnet(&nlhelper->net));
}
