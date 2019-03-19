Return-Path: <SRS0=OoGW=RW=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.0 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_PASS,USER_AGENT_NEOMUTT autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 47AD5C43381
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 07:17:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 1F2E920872
	for <netfilter-devel@archiver.kernel.org>; Tue, 19 Mar 2019 07:17:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725988AbfCSHRI (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 19 Mar 2019 03:17:08 -0400
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:49846 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725862AbfCSHRI (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 19 Mar 2019 03:17:08 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.89)
        (envelope-from <fw@strlen.de>)
        id 1h68zh-0002Db-UG; Tue, 19 Mar 2019 08:17:06 +0100
Date:   Tue, 19 Mar 2019 08:17:05 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Karuna Grewal <karunagrewal98@gmail.com>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [nftables] tests/py: Add Test for `meta time`
Message-ID: <20190319071705.lyjjd3dqz2zwc6vm@breakpoint.cc>
References: <20190318094745.GA4394@nebula>
 <CAHRz_yZMsP2RQPu=8pTigq8SrYz9xYSef3S_d4ORAMkkYDEv4Q@mail.gmail.com>
 <20190318105545.qz5oddbjah4qc4fa@breakpoint.cc>
 <CAHRz_yYk_Yq5+Tp1J1jT2rVT0pHWjH37-F8Rdi1XCLWj79J6rg@mail.gmail.com>
 <20190318220923.5v64yccan6shhpnq@breakpoint.cc>
 <CAHRz_yY=yrrMJS98s6cq9sRP_nrSNrv5kKCPxKT+BAj_GGS5hw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAHRz_yY=yrrMJS98s6cq9sRP_nrSNrv5kKCPxKT+BAj_GGS5hw@mail.gmail.com>
User-Agent: NeoMutt/20170113 (1.7.2)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Karuna Grewal <karunagrewal98@gmail.com> wrote:
> On Tue, Mar 19, 2019 at 3:39 AM Florian Westphal <fw@strlen.de> wrote:
> >
> > Karuna Grewal <karunagrewal98@gmail.com> wrote:
> > > command: add rule ip test-ip4 input meta time 100
> > > Error: Could not process rule: Operation not supported
> >
> > This means that nft_meta.c doesn't recognize the TIME key.
> > You need to run the modified/patched kernel for this to work --
> > it looks like nft_meta_get_init() hits the "default:" switch label.
> I'm running the tests against the new modified kernel (I've applied
> the patch to kernel 5.0.2) and when I logged a debug message it
> confirms that it's indeed hitting the default switch.
> But previously running nft against the nf-next fork of the kernel was
> recognising the `meta time`. This leaves me in a bit of confusion.
> Meanwhile I'm trying to verify other things, could you please confirm
> if the kernel tree isn't any issue here.

It looks like kernel and userspace disagree on the TIME_NS meta attribute
enum value.
