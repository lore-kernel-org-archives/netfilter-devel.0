Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC786C77B75
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 Apr 2023 19:50:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232686AbjDRTuH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 Apr 2023 15:50:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51988 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232683AbjDRTuG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 Apr 2023 15:50:06 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:237:300::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CB6BD9EDB;
        Tue, 18 Apr 2023 12:50:02 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1porKz-0006R5-2m; Tue, 18 Apr 2023 21:50:01 +0200
Date:   Tue, 18 Apr 2023 21:50:01 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Florian Westphal <fw@strlen.de>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        dxu@dxuuu.xyz, qde@naccy.de
Subject: Re: [PATCH bpf-next v3 5/6] tools: bpftool: print netfilter link info
Message-ID: <20230418195001.GB21058@breakpoint.cc>
References: <20230418131038.18054-1-fw@strlen.de>
 <20230418131038.18054-6-fw@strlen.de>
 <b325e432-7652-96d3-055a-0107a88ea1fa@isovalent.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b325e432-7652-96d3-055a-0107a88ea1fa@isovalent.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Quentin Monnet <quentin@isovalent.com> wrote:
> > +			if (nf_link_count > (INT_MAX / sizeof(info))) {
> > +				fprintf(stderr, "link count %d\n", nf_link_count);
> 
> The only nit I have is that we could use p_err() here, and have a more
> descriptive message (letting user know that we've reached a limit).

Drats, I'll replace this and will retain your RvB tag in v4, thanks.
