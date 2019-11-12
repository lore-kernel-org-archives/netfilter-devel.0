Return-Path: <SRS0=y7H9=ZE=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0B16FC43331
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 18:53:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id D465B21783
	for <netfilter-devel@archiver.kernel.org>; Tue, 12 Nov 2019 18:53:48 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NXTd/SzG";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="NXTd/SzG"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726952AbfKLSxs (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 12 Nov 2019 13:53:48 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:57774 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725997AbfKLSxs (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 12 Nov 2019 13:53:48 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id 9651460FF6; Tue, 12 Nov 2019 18:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573584827;
        bh=LymqdnZqSifkAUeS2UeV0PxtVaEbPME4cmdgtInp2JY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NXTd/SzG+IKrr95V/1fYAgKlze97VOftoqdMghE7ELGNqjCCHU+GVc81q6V91dGVd
         mJBLGVIxY5QtTD8d2M5BI0sbDFC/5r0p2NGZ22COBiiwhs4oMdI6raRPPU0MyZvujw
         vvFEI+YTyP1cQoknM3gb2lmuUqenu4ev2lTjgXhU=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id EDC9E60FF7;
        Tue, 12 Nov 2019 18:53:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1573584827;
        bh=LymqdnZqSifkAUeS2UeV0PxtVaEbPME4cmdgtInp2JY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NXTd/SzG+IKrr95V/1fYAgKlze97VOftoqdMghE7ELGNqjCCHU+GVc81q6V91dGVd
         mJBLGVIxY5QtTD8d2M5BI0sbDFC/5r0p2NGZ22COBiiwhs4oMdI6raRPPU0MyZvujw
         vvFEI+YTyP1cQoknM3gb2lmuUqenu4ev2lTjgXhU=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Wed, 13 Nov 2019 00:23:46 +0530
From:   manojbm@codeaurora.org
To:     Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org, subashab@quicinc.com,
        sharathv@qti.qualcomm.com, ssaha@qti.qualcomm.com,
        vidulak@qti.qualcomm.com, bryanh@quicinc.com,
        jovanar@qti.qualcomm.com, manojbm@qti.qualcomm.com
Subject: Re: [PATCH] netfilter: xtables: Add snapshot of hardidletimer target
In-Reply-To: <20191112111424.GE19558@breakpoint.cc>
References: <20191111065617.GA29048@manojbm-linux.ap.qualcomm.com>
 <20191112111424.GE19558@breakpoint.cc>
Message-ID: <d5ebd8d0d6fa6bb0c102a822c17c6060@codeaurora.org>
X-Sender: manojbm@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2019-11-12 16:44, Florian Westphal wrote:
> Manoj Basapathi <manojbm@codeaurora.org> wrote:
>> When the timer expires, the target module sends a sysfs notification
>> to the userspace, which can then decide what to do (eg. disconnect to
>> save power)
>> 
>> Compared to xt_IDLETIMER, xt_HARDIDLETIMER can send notifications when
>> CPU is in suspend too, to notify the timer expiry.
> 
> Would it make sense to add this feature to IDLETIMER instead of a new
> module? AFAICS there is a lot of boilerplate overlap between those two.


Its a feature specific module .Keeping it as a separate module helps us 
to enable and disable it via defconfig.
As iptable rules are target specific , it also helps iptable rules run 
independently and easier to debug .
