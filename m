Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 7646CC433FE
	for <netfilter-devel@archiver.kernel.org>; Fri, 11 Nov 2022 11:09:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232907AbiKKLJm (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 11 Nov 2022 06:09:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233671AbiKKLJd (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 11 Nov 2022 06:09:33 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id E930D663F6
        for <netfilter-devel@vger.kernel.org>; Fri, 11 Nov 2022 03:09:31 -0800 (PST)
Date:   Fri, 11 Nov 2022 12:09:28 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Robert O'Brien <robrien@foxtrot-research.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: PATCH ulogd2 filter BASE ARP packet IP addresses
Message-ID: <Y24taNAVtz53JPDB@salvia>
References: <004301d8f531$bb2c60c0$31852240$@foxtrot-research.com>
 <005601d8f532$49cd7080$dd685180$@foxtrot-research.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <005601d8f532$49cd7080$dd685180$@foxtrot-research.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Thu, Nov 10, 2022 at 01:28:53PM -0500, Robert O'Brien wrote:
> I am developing for an embedded target and just recently deployed
> libnetfilter and ulogd2 for logging packets which are rejected by rules in
> ebtables. While performing this effort I discovered a bug which generates
> incorrect values in the arp.saddr and arp.daddr fields in the OPRINT and
> GPRINT outputs. I created a patch to resolve this issue in my deployment and
> I believe it is a candidate for integration into the repository. The files
> that this patch modifies have not changed in many years so I'm thinking that
> the bug appeared due to changes in another codebase but I'm not sure. Please
> review and provide feedback.

Could you post an example ulogd configuration file to reproduce the
issue?

> P.S. I could not find a way to submit a patch via Patchwork so I am writing
> this email and attaching the patch. If there is a better way to submit a
> patch, please tell me and I will re-submit it that way.

For patches to show up in patchwork, you have to use the git
format-patch and git send-email tools.

Thanks.
