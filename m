Return-Path: <SRS0=5/AD=YL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,PDS_TONAME_EQ_TOLOCAL_SHORT,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 76613CA9EA0
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 10:51:26 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 4B36021897
	for <netfilter-devel@archiver.kernel.org>; Fri, 18 Oct 2019 10:51:26 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389105AbfJRKv0 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 18 Oct 2019 06:51:26 -0400
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:34344 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725906AbfJRKvZ (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 18 Oct 2019 06:51:25 -0400
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1iLPqp-0002g3-LZ; Fri, 18 Oct 2019 12:51:19 +0200
Date:   Fri, 18 Oct 2019 12:51:19 +0200
From:   Florian Westphal <fw@strlen.de>
To:     wenxu <wenxu@ucloud.cn>
Cc:     Florian Westphal <fw@strlen.de>, pablo@netfilter.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: nf_tables: add vlan support
Message-ID: <20191018105119.GZ25052@breakpoint.cc>
References: <1571392968-1263-1-git-send-email-wenxu@ucloud.cn>
 <20191018102402.GY25052@breakpoint.cc>
 <e7714199-ac8e-af7b-dc86-15f3aa19d3b2@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e7714199-ac8e-af7b-dc86-15f3aa19d3b2@ucloud.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

wenxu <wenxu@ucloud.cn> wrote:
> > If you plan to extend this in the future then I'm fine with keeping it
> > as a module.
> It can add vlan tci / proto "get" expr and It also can support offload things in the future.

Ok, lets keep it as a module then.
