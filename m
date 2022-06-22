Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 04A67C433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 22 Jun 2022 10:42:15 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351363AbiFVKmN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 22 Jun 2022 06:42:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237538AbiFVKmM (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 22 Jun 2022 06:42:12 -0400
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 246913BA52
        for <netfilter-devel@vger.kernel.org>; Wed, 22 Jun 2022 03:42:11 -0700 (PDT)
Date:   Wed, 22 Jun 2022 12:42:05 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Mikhail Sennikovsky <mikhail.sennikovskii@ionos.com>
Cc:     netfilter-devel@vger.kernel.org, mikhail.sennikovsky@gmail.com
Subject: Re: [PATCH 1/3] conntrack: introduce new -A command
Message-ID: <YrLx/QDoF/1OHyvc@salvia>
References: <20220621225547.69349-1-mikhail.sennikovskii@ionos.com>
 <20220621225547.69349-2-mikhail.sennikovskii@ionos.com>
 <YrK/LuvlSQVtED0a@salvia>
 <CALHVEJa-ugo2FrF2huaJptA_Vh3XWNHm2=sbndieiEZb1HVc8A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CALHVEJa-ugo2FrF2huaJptA_Vh3XWNHm2=sbndieiEZb1HVc8A@mail.gmail.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Jun 22, 2022 at 12:27:05PM +0200, Mikhail Sennikovsky wrote:
> Hi Pablo,
> 
> I initially decided against it because Introducing a separate CT_ADD
> command would
> result in lots of actually unnecessary changes in lots of places, e.g.
> the optset arrays definitions (passed to generic_opt_check) in
> conntrac.c and all extensions would need a new (actually duplicate)
> entry for the CT_ADD, e.g. here
> https://git.netfilter.org/conntrack-tools/tree/extensions/libct_proto_dccp.c#n67
> But if you prefer this approach, I can surely do that. Let me adjust &
> submit an updated patch then.

That's basically:

- update commands_v_options
- update cmd2type
- update exit_msg
- update err2str
- add extra CT_ADD case in switch.
- add CT_ADD as a valid command for batch mode

That should be fine, I prefer if -A fully qualifies as a command, not as a flag.
