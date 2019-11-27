Return-Path: <SRS0=TrSD=ZT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 4BEC0C432C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 15:08:42 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 20ACE20674
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 15:08:42 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726729AbfK0PIl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 10:08:41 -0500
Received: from orbyte.nwl.cc ([151.80.46.58]:38918 "EHLO orbyte.nwl.cc"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726603AbfK0PIl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 10:08:41 -0500
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.91)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1iZyvk-0001E4-KU; Wed, 27 Nov 2019 16:08:36 +0100
Date:   Wed, 27 Nov 2019 16:08:36 +0100
From:   Phil Sutter <phil@nwl.cc>
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Laura Garcia <nevola@gmail.com>
Subject: Re: Operation not supported when adding jump command
Message-ID: <20191127150836.GJ8016@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@nwl.cc>,
        "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>,
        Arturo Borrero Gonzalez <arturo@netfilter.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Laura Garcia <nevola@gmail.com>
References: <20191126122110.GD795@breakpoint.cc>
 <3DBD9E39-A0DF-4A69-93CC-4344617BDB2F@cisco.com>
 <20191126153850.pblaoj4xklfz5jgv@salvia>
 <427E92A6-2FFA-47CF-BF3B-C08961C978C9@cisco.com>
 <20191126155125.GD8016@orbyte.nwl.cc>
 <0A92D5EA-B158-4C7A-B85C-1692AE7C828B@cisco.com>
 <20191126192752.GE8016@orbyte.nwl.cc>
 <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
 <3a457e5b-be8f-e99d-fb0d-4826a15a4a55@netfilter.org>
 <89C24159-37F8-4D2F-B391-8A1D6AE403E7@cisco.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <89C24159-37F8-4D2F-B391-8A1D6AE403E7@cisco.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Serguei,

On Wed, Nov 27, 2019 at 02:36:07PM +0000, Serguei Bezverkhi (sbezverk) wrote:
> Thanks a lot for your reply, my ultimate goal is to develop kube-proxy which is building  nftables rules instead of iptables, in addition the goal is to use direct API calls to netlink without any external dependencies and of course to try to leverage nftables' advanced features to achieve the best performance.
> 
> I am in the process of identifying gaps in functionality available in github.com/google/nftables and github.com/sbezverk/nftableslib libraries, example yesterday I found out that neither of these libraries supports "numgen", which would be a mandatory feature to support load balancing between service's multiple end points.  I will have to add it to both to be able to move forward.
> I use iptables from a working cluster and try to build a code which would program nftables the same way (with optimization). Once it is done, then it can be arranged into a controller listening for svc/endpoints and program  into nftables accordingly.
> 
> I am looking for people interested in the same topic to be able to discuss different approaches, like it was done yesterday with Phil and select the best approach to make nftables to shine (
> 
> Please let me know if you are interested in further discussions.

Yes, we're definitely interested further discussion/cooperation. You're
using the JSON API for nftableslib, right?

Cheers, Phil
