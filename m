Return-Path: <SRS0=irZF=R4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.5 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_MUTT autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EFEBAC43381
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Mar 2019 10:44:45 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3BF82085A
	for <netfilter-devel@archiver.kernel.org>; Mon, 25 Mar 2019 10:44:45 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730713AbfCYKop (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 25 Mar 2019 06:44:45 -0400
Received: from orbyte.nwl.cc ([151.80.46.58]:49620 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730633AbfCYKop (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 25 Mar 2019 06:44:45 -0400
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1h8N5t-0006Rc-IB; Mon, 25 Mar 2019 11:44:41 +0100
Date:   Mon, 25 Mar 2019 11:44:41 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     Karuna Grewal <karunagrewal98@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: Implementing Deletion of Set Elements in Rulesets
Message-ID: <20190325104441.GQ4851@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        Karuna Grewal <karunagrewal98@gmail.com>,
        Florian Westphal <fw@strlen.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org
References: <20190321084516.6qmr23meelir7uc3@breakpoint.cc>
 <CAHRz_yZQ8JYq90BCTKoN7SsivWpXMsGiFz2WkmxbX2S2aVj81Q@mail.gmail.com>
 <20190321110802.GI4851@orbyte.nwl.cc>
 <CAHRz_yazsKDFYfsVemDLd4av3M+3k6MJnctvFYYMjDD7q2zSMA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRz_yazsKDFYfsVemDLd4av3M+3k6MJnctvFYYMjDD7q2zSMA@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Sat, Mar 23, 2019 at 11:10:24PM +0530, Karuna Grewal wrote:
> Thanks a lot Phil. This was lucid indeed. I still have a few more doubts:
> * what's the purpose of  a context (netlink or eval)?

Contexts provide context. ;)
E.g. nft_ctx holds application information like configured output/error
file descriptors.
In general, these context structures are used to provide data to
functions further down in the call stack without the need for excessive
amounts of function parameters or use of global variables (which should
be avoided for obvious reasons).
If you want to know more about where and how they are used, look up what
fields are contained in each context struct and where they are
instantiated.

> * What is the purpose of the cache being used after the netlink message has
> been already sent to the kernel?

Cache belongs to nft_ctx, which is created by the application. The
application may run multiple commands so keeping the cache after a
commit to kernel is useful. I think it is used from echo callback as
well, although I can't find an example right now.

> * Could you please explain a bit about the kernel interaction once the
> netlink message is sent esp. which structures store the data which was
> carried by the message from userpace. I'm aware of the concept of hooks
> being registered and thereon the processing is handled by the netfilter
> code but I'm not completely clear about how the netlink message gets
> handled internally.

Libnftables objects (struct rule, struct chain, etc.) are converted into
libnftnl objects (struct nftnl_rule, struct nftnl_chain, etc.) within
libnftables. In libnftnl, there are *_build_payload() functions which
serialize libnftnl objects into a netlink message identified by an
instance of struct nlmsghdr.

Netlink messages contain a static header (see struct nlmsghdr) and an
arbitrary amount of attributes of the form [len, type, data]. Libnftnl
uses libmnl to append those attributes to a message. In order to find
out where and how a given netlink message is handled in the kernel, the
quickest way is often to grep for some attribute type definition.

One caveat with nlmsg attributes is that libnftnl and kernel have
distinct ones. E.g. NFTNL_TABLE_NAME in libnftnl corresponds with
NFTA_TABLE_NAME in kernel. See *_build_payload() functions in libnftnl
for details, but in general NFTNL_FOO corresponds with NFTA_FOO in
kernel.

Cheers, Phil
