Return-Path: <SRS0=LpWG=7J=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-13.2 required=3.0
	tests=HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 3C263C433E0
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 14:53:21 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 226772078B
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 May 2020 14:53:21 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389385AbgE0OxU (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 May 2020 10:53:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388738AbgE0OxU (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 May 2020 10:53:20 -0400
Received: from Chamillionaire.breakpoint.cc (Chamillionaire.breakpoint.cc [IPv6:2a0a:51c0:0:12e:520::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 780DFC05BD1E
        for <netfilter-devel@vger.kernel.org>; Wed, 27 May 2020 07:53:20 -0700 (PDT)
Received: from fw by Chamillionaire.breakpoint.cc with local (Exim 4.92)
        (envelope-from <fw@strlen.de>)
        id 1jdxQj-00084U-6n; Wed, 27 May 2020 16:53:17 +0200
Date:   Wed, 27 May 2020 16:53:17 +0200
From:   Florian Westphal <fw@strlen.de>
To:     Richard Guy Briggs <rgb@redhat.com>
Cc:     Linux-Audit Mailing List <linux-audit@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, Paul Moore <paul@paul-moore.com>,
        sgrubb@redhat.com, omosnace@redhat.com, fw@strlen.de,
        twoerner@redhat.com, eparis@parisplace.org, tgraf@infradead.org
Subject: Re: [PATCH ghak124 v1] audit: log nftables configuration change
 events
Message-ID: <20200527145317.GI2915@breakpoint.cc>
References: <d92a718b54269f426acc18f28e561031da66d3ca.1590579994.git.rgb@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d92a718b54269f426acc18f28e561031da66d3ca.1590579994.git.rgb@redhat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Richard Guy Briggs <rgb@redhat.com> wrote:
> iptables, ip6tables, arptables and ebtables table registration,
> replacement and unregistration configuration events are logged for the
> native (legacy) iptables setsockopt api, but not for the
> nftables netlink api which is used by the nft-variant of iptables in
> addition to nftables itself.
> 
> Add calls to log the configuration actions in the nftables netlink api.
> 
> This uses the same NETFILTER_CFG record format.

I know little about audit records.  Does this allow the user to figure
out that this record is created via nf_tables/netlink rather than xtables?

> For further information please see issue
> https://github.com/linux-audit/audit-kernel/issues/124
> 
> Signed-off-by: Richard Guy Briggs <rgb@redhat.com>
> ---
> This is an RFC patch.
> Note: I have questions about the "entries" count.  Is there a more
> appropriate or relevant item to report here?
> Note: It might make sense to differentiate in the op= field that this
> was a legacy call vs an nft call.  At the moment, legacy calls overlap
> with nft table calls, which are similar calls.
> 
>  include/linux/audit.h         |  7 +++++++
>  kernel/auditsc.c              | 12 +++++++++---
>  net/netfilter/nf_tables_api.c | 14 ++++++++++++++
>  3 files changed, 30 insertions(+), 3 deletions(-)
> 
> diff --git a/include/linux/audit.h b/include/linux/audit.h
> index 3fcd9ee49734..b10f54103a82 100644
> --- a/include/linux/audit.h
> +++ b/include/linux/audit.h
> @@ -12,6 +12,7 @@
>  #include <linux/sched.h>
>  #include <linux/ptrace.h>
>  #include <uapi/linux/audit.h>
> +#include <uapi/linux/netfilter/nf_tables.h>
>  
>  #define AUDIT_INO_UNSET ((unsigned long)-1)
>  #define AUDIT_DEV_UNSET ((dev_t)-1)
> @@ -98,6 +99,12 @@ enum audit_nfcfgop {
>  	AUDIT_XT_OP_REGISTER,
>  	AUDIT_XT_OP_REPLACE,
>  	AUDIT_XT_OP_UNREGISTER,
> +	AUDIT_XT_OP_CHAIN_REGISTER	= NFT_MSG_NEWCHAIN,

Hmm, this means AUDIT_XT_OP_CHAIN_REGISTER overlaps with the 4th
audit_nfcfgop value...?

> +	AUDIT_XT_OP_CHAIN_NOOP		= NFT_MSG_GETCHAIN,

GETCHAIN can't appear in the commit path (its not changing anything).
Same for all other NFT_MSG_FOO that use ".call_rcu" action.

Futhermore, I wonder what is to be logged by audit.

The fact that there was 'some change'? If so, its enough to log
the increment of the generation count during the commit phase.

(After that, kernel can't back down anymore, i.e. all errors are
 caught/handled beforehand).

If its 'any config change', then you also need to handle adds
or delete from sets/maps, since that may allow something that wasn't
allowed before, e.g. consider

ip saddr @trused accept

and then, later on,
nft add element ip filter @trusted { 10.0.0.0/8, 192.168.0.1 }

This would not add a table, or chain, or set, but it does implicitly
alter the ruleset.

> +		case NFT_MSG_DELRULE:
> +			audit_log_nfcfg(trans->ctx.table->name,
> +					trans->ctx.family,
> +					atomic_read(&trans->ctx.table->chains_ht.ht.nelems),
> +					trans->msg_type);
> +			break;

Is that record format expected to emit the current number of chains?
I'm not sure if that info is meaningful.

Since table names can be anything in nf_tables (they have no special
properties anymore), the table name is interesting from a informational
pov, but not super interesting.

This will also emit the same message/record multiple times, with only
difference being the msg_type.  I'm not sure thats interesting.

Consider a batch update that commits 100 new rules in chain x,
this would result in 100 audit_log_nfcfg() calls, each with the
same information.

There are test cases in nftables.git, you could run them to see what
kind of audit events are generated and how redundant they might be.

