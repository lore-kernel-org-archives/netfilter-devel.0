Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.2 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 13160C4338F
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 08:58:09 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id E0E2F61057
	for <netfilter-devel@archiver.kernel.org>; Mon,  2 Aug 2021 08:58:08 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232788AbhHBI6Q (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 2 Aug 2021 04:58:16 -0400
Received: from mail.netfilter.org ([217.70.188.207]:49226 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232711AbhHBI6P (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 2 Aug 2021 04:58:15 -0400
Received: from netfilter.org (bl11-146-165.dsl.telepac.pt [85.244.146.165])
        by mail.netfilter.org (Postfix) with ESMTPSA id A2CD76003A;
        Mon,  2 Aug 2021 10:57:30 +0200 (CEST)
Date:   Mon, 2 Aug 2021 10:57:59 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: ebtables: do not hook tables by
 default
Message-ID: <20210802085759.GB1092@salvia>
References: <20210723131801.7594-1-fw@strlen.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20210723131801.7594-1-fw@strlen.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Fri, Jul 23, 2021 at 03:18:01PM +0200, Florian Westphal wrote:
> If any of these modules is loaded, hooks get registered in all netns:
> 
> Before: 'unshare -n nft list hooks' shows:
> family bridge hook prerouting {
> 	-2147483648 ebt_broute
> 	-0000000300 ebt_nat_hook
> }
> family bridge hook input {
> 	-0000000200 ebt_filter_hook
> }
> family bridge hook forward {
> 	-0000000200 ebt_filter_hook
> }
> family bridge hook output {
> 	+0000000100 ebt_nat_hook
> 	+0000000200 ebt_filter_hook
> }
> family bridge hook postrouting {
> 	+0000000300 ebt_nat_hook
> }
> 
> This adds 'template 'tables' for ebtables.
> 
> Each ebtable_foo registers the table as a template, with an init function
> that gets called once the first get/setsockopt call is made.
> 
> ebtables core then searches the (per netns) list of tables.
> If no table is found, it searches the list of templates instead.
> If a template entry exists, the init function is called which will
> enable the table and register the hooks (so packets are diverted
> to the table).
> 
> If no entry is found in the template list, request_module is called.
> 
> After this, hook registration is delayed until the 'ebtables'
> (set/getsockopt) request is made for a given table and will only
> happen in the specific namespace.

Applied, thanks.
