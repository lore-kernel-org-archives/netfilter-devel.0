Return-Path: <SRS0=+t1+=4B=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 853BEC2BA83
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 12:35:03 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 661D620578
	for <netfilter-devel@archiver.kernel.org>; Thu, 13 Feb 2020 12:35:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729820AbgBMMfA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 13 Feb 2020 07:35:00 -0500
Received: from Chamillionaire.breakpoint.cc ([193.142.43.52]:47840 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729531AbgBMMfA (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Feb 2020 07:35:00 -0500
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1j2Dhp-0004oY-Ks; Thu, 13 Feb 2020 13:34:57 +0100
Date:   Thu, 13 Feb 2020 13:34:57 +0100
From:   Florian Westphal <fw@strlen.de>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Florian Westphal <fw@strlen.de>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux-Audit Mailing List <linux-audit@redhat.com>,
        netfilter-devel@vger.kernel.org, ebiederm@xmission.com,
        twoerner@redhat.com, eparis@parisplace.org, tgraf@infradead.org
Subject: Re: [PATCH ghak25 v2 8/9] netfilter: add audit operation field
Message-ID: <20200213123457.GO2991@breakpoint.cc>
References: <cover.1577830902.git.rgb@redhat.com>
 <6768f7c7d9804216853e6e9c59e44f8a10f46b99.1577830902.git.rgb@redhat.com>
 <20200106202306.GO795@breakpoint.cc>
 <20200213121410.b2dsh2kwg3k7xg7e@madcap2.tricolour.ca>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200213121410.b2dsh2kwg3k7xg7e@madcap2.tricolour.ca>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> wrote:
> The default policy is NF_ACCEPT (because Rusty didn't want
> more email, go figure...).  It occurred to me later that some table
> loads took a command line parameter to be able to change the default
> policy verdict from NF_ACCEPT to NF_DROP.  In particular, filter FORWARD
> hook tables.  Is there a straightforward way to be able to detect this
> in all the audit_nf_cfg() callers to be able to log it?  In particular,
> in:
> 	net/bridge/netfilter/ebtables.c: ebt_register_table()
> 	net/bridge/netfilter/ebtables.c: do_replace_finish()
> 	net/bridge/netfilter/ebtables.c: __ebt_unregister_table()
> 	net/netfilter/x_tables.c: xt_replace_table()
> 	net/netfilter/x_tables.c: xt_unregister_table()

The module parameter or the policy?

The poliy can be changed via the xtables tools.
Given you can have:

*filter
:INPUT ACCEPT [0:0]
:FORWARD DROP [0:0]
:OUTPUT ACCEPT [0:0]
-A FORWARD -j ACCEPT
COMMIT

... which effectily gives a FORWARD ACCEPT policy I'm not sure logging
the policy is useful.

Furthermore, ebtables has polices even for user-defined chains.

> Both potential solutions are awkward, adding a parameter to pass that
> value in, but also trying to reach into the protocol-specific entry
> table to find that value.  Would you have a recommendation?  This
> assumes that reporting that default policy value is even desired or
> required.

See above, I don't think its useful.  If it is needed, its probably best
to define an informational struct containing the policy (accept/drop)
value for the each hook points (prerouting to postrouting),  fill
that from the backend specific code (as thats the only place that
exposes the backend specific structs ...) and then pass that to
the audit logging functions.
