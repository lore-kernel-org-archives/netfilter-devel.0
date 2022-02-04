Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5EF40C433F5
	for <netfilter-devel@archiver.kernel.org>; Fri,  4 Feb 2022 04:43:03 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356681AbiBDEnC (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 3 Feb 2022 23:43:02 -0500
Received: from mail.netfilter.org ([217.70.188.207]:49052 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231887AbiBDEnB (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 3 Feb 2022 23:43:01 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 9B48660195;
        Fri,  4 Feb 2022 05:42:55 +0100 (CET)
Date:   Fri, 4 Feb 2022 05:42:58 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org,
        Pham Thanh Tuyen <phamtyn@gmail.com>
Subject: Re: [PATCH nf] netfilter: ctnetlink: disable helper autoassign
Message-ID: <Yfyu0n5us5SR9M4j@salvia>
References: <20220202110056.22574-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20220202110056.22574-1-fw@strlen.de>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Wed, Feb 02, 2022 at 12:00:56PM +0100, Florian Westphal wrote:
> When userspace, e.g. conntrackd, inserts an entry with a specified helper,
> its possible that the helper is lost immediately after its added:
> 
> ctnetlink_create_conntrack
>   -> nf_ct_helper_ext_add + assign helper
>     -> ctnetlink_setup_nat
>       -> ctnetlink_parse_nat_setup
>          -> parse_nat_setup -> nfnetlink_parse_nat_setup
> 	                       -> nf_nat_setup_info
>                                  -> nf_conntrack_alter_reply
>                                    -> __nf_ct_try_assign_helper
> 
> ... and __nf_ct_try_assign_helper will zero the helper again.
> 
> Set IPS_HELPER bit to bypass auto-assign logic, its unwanted, just like
> when helper is assigned via ruleset.
> 
> Dropped old 'not strictly necessary' comment, it referred to use of
> rcu_assign_pointer() before it got replaced by RCU_INIT_POINTER().
> 
> NB: Fixes tag intentionally incorrect, this extends the referenced commit,
> but this change won't build without IPS_HELPER introduced there.

Applied.
