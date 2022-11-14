Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8B389C4321E
	for <netfilter-devel@archiver.kernel.org>; Mon, 14 Nov 2022 18:13:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238221AbiKNSNN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 14 Nov 2022 13:13:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41140 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238257AbiKNSNC (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 14 Nov 2022 13:13:02 -0500
Received: from mail.netfilter.org (mail.netfilter.org [217.70.188.207])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 8C58424BD3
        for <netfilter-devel@vger.kernel.org>; Mon, 14 Nov 2022 10:13:01 -0800 (PST)
Date:   Mon, 14 Nov 2022 19:12:58 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Robert O'Brien <robrien@foxtrot-research.com>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: PATCH ulogd2 filter BASE ARP packet IP addresses
Message-ID: <Y3KFKuhzFWbbAKWL@salvia>
References: <004301d8f531$bb2c60c0$31852240$@foxtrot-research.com>
 <005601d8f532$49cd7080$dd685180$@foxtrot-research.com>
 <Y24taNAVtz53JPDB@salvia>
 <001c01d8f851$38ac6050$aa0520f0$@foxtrot-research.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <001c01d8f851$38ac6050$aa0520f0$@foxtrot-research.com>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Nov 14, 2022 at 12:47:52PM -0500, Robert O'Brien wrote:
> I will create a bug report and attach an example ulogd configuration
> file that demonstrates the issue.

OK.

> I will send a patch using git send-email and mention it in my bug
> report. What is the email address to where I should send the patch?

Please use netfilter-devel@vger.kernel.org so patchwork catches this
patch.

Thanks.
