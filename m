Return-Path: <SRS0=TrSD=ZT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5DE47C432C0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 16:06:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 3567920665
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 16:06:51 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726909AbfK0QGv (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 11:06:51 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:39024 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726593AbfK0QGu (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 11:06:50 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iZzq2-0002sk-F0; Wed, 27 Nov 2019 17:06:46 +0100
Date:   Wed, 27 Nov 2019 17:06:46 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Laura Garcia <nevola@gmail.com>
Subject: Re: Operation not supported when adding jump command
Message-ID: <20191127160646.GK8016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Laura Garcia <nevola@gmail.com>
References: <20191126153850.pblaoj4xklfz5jgv@salvia>
 <427E92A6-2FFA-47CF-BF3B-C08961C978C9@cisco.com>
 <20191126155125.GD8016@orbyte.nwl.cc>
 <0A92D5EA-B158-4C7A-B85C-1692AE7C828B@cisco.com>
 <20191126192752.GE8016@orbyte.nwl.cc>
 <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
 <3a457e5b-be8f-e99d-fb0d-4826a15a4a55@netfilter.org>
 <89C24159-37F8-4D2F-B391-8A1D6AE403E7@cisco.com>
 <20191127150836.GJ8016@orbyte.nwl.cc>
 <3AE9B74A-37FB-4CDA-86FB-143F506D6C77@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3AE9B74A-37FB-4CDA-86FB-143F506D6C77@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

On Wed, Nov 27, 2019 at 03:35:04PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> No, I do not, nftableslib talks directly talk to netlink connection.
> 
> nftableslib offers an API which allows create tables/chains/rules and exposes an interface which looks similar to k8s client-go.  If you check https://github.com/sbezverk/nftableslib/blob/master/cmd/e2e/e2e.go
> 
> It will give you a good idea how it operates.
> 
> The reason for going in this direction is  performance, for a relatively static applications like a firewall, json approach is great, but for applications like a kube-proxy where hundreds or even thousands of service/endpoint events happen, I do not believe json is a right approach. When I talked to api machinery folks I was given 5k events per second as a target.

So you're bypassing both libnftables and libnftnl. Those 5k events per
second are a benchmark, not an expected load, right?

While you're obviously searching for the most performance, the drawback
is complexity. Using JSON (and thereby libnftables and libnftnl as
backends) a task like utilizing numgen expression is relatively simple.

A problem you won't get rid of with the move from iptables to nftables
is concurrent use: The "let's insert our rules on top" approach to
dealing with an existing ruleset or other users is obviously not the
best one. I guess you're aiming at dedicated applications where this is
not an issue but for "general purpose" applications I guess a k8s
backend communicating with firewalld would be a good approach of
customizing host's firewall setup without stepping onto others' toes.

Back to topic, you are creating a static ruleset based on the iptables
one you got for simple comparison tests or are you already over that? If
not, I guess it would be a good basis for high level ruleset
optimization discussions.

Cheers, Phil
