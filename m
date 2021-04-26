Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-10.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id E4D92C433B4
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 10:57:20 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id A6C82611CE
	for <netfilter-devel@archiver.kernel.org>; Mon, 26 Apr 2021 10:57:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232787AbhDZK6A (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 26 Apr 2021 06:58:00 -0400
Received: from mail.netfilter.org ([217.70.188.207]:50668 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233006AbhDZK6A (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 26 Apr 2021 06:58:00 -0400
Received: from us.es (unknown [90.77.255.23])
        by mail.netfilter.org (Postfix) with ESMTPSA id B4C0364123;
        Mon, 26 Apr 2021 12:56:40 +0200 (CEST)
Date:   Mon, 26 Apr 2021 12:57:14 +0200
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Jan Engelhardt <jengelh@inai.de>
Cc:     Florian Westphal <fw@strlen.de>, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf-next] netfilter: allow to turn off xtables compat layer
Message-ID: <20210426105714.GA300@salvia>
References: <20210426101440.25335-1-fw@strlen.de>
 <25p6qsnp-r7p1-ps60-s7np-nsq1899446n2@vanv.qr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <25p6qsnp-r7p1-ps60-s7np-nsq1899446n2@vanv.qr>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Apr 26, 2021 at 12:47:12PM +0200, Jan Engelhardt wrote:
> 
> On Monday 2021-04-26 12:14, Florian Westphal wrote:
> 
> >The compat layer needs to parse untrusted input (the ruleset)
> >to translate it to a 64bit compatible format.
> >
> >We had a number of bugs in this department in the past, so allow users
> >to turn this feature off.
> >
> >+++ b/include/linux/netfilter/x_tables.h
> >@@ -158,7 +158,7 @@ struct xt_match {
> > 
> > 	/* Called when entry of this type deleted. */
> > 	void (*destroy)(const struct xt_mtdtor_param *);
> >-#ifdef CONFIG_COMPAT
> >+#ifdef CONFIG_NETFILTER_XTABLES_COMPAT
> > 	/* Called when userspace align differs from kernel space one */
> > 	void (*compat_from_user)(void *dst, const void *src);
> > 	int (*compat_to_user)(void __user *dst, const void *src);
> 
> There are not a lot of '\.compat_to_user' instaces anymore. It would appear we
> managed to throw out most of the flexing structs over the past 15 years.
> 
> Perhaps the remaining one (struct xt_rateinfo) could be respecified
> as a v1, with the plan to ditch the v0.
> 
> Then the entire xtables_compat code could go as well.

If the remaining matches and targets that rely on this get a new
revision to fix their structure layout issues, then this entire layer
could be peeled off.
