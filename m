Return-Path: <SRS0=0Xdd=RL=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS autolearn=ham
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 62AFBC43381
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 01:28:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 30F1820675
	for <netfilter-devel@archiver.kernel.org>; Fri,  8 Mar 2019 01:28:36 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FJIPVWIa";
	dkim=fail reason="key not found in DNS" (0-bit key) header.d=codeaurora.org header.i=@codeaurora.org header.b="FJIPVWIa"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726250AbfCHB2f (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 7 Mar 2019 20:28:35 -0500
Received: from smtp.codeaurora.org ([198.145.29.96]:41328 "EHLO
        smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726242AbfCHB2f (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 7 Mar 2019 20:28:35 -0500
Received: by smtp.codeaurora.org (Postfix, from userid 1000)
        id EC92D60159; Fri,  8 Mar 2019 01:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552008514;
        bh=WaeaKJeULhzsi4TWI2pBOhZFiXwA0IGTmWyU7Rob840=;
        h=Date:From:To:Subject:From;
        b=FJIPVWIa97+UhdlrGm3hldd0/2tFcILMQC4RnAyJ8WfJNtqtYEfnDgYr79YYUrmg5
         aZJWqkuFB3iMrv2nAOTnIUsaicw1yVTjrSHHmiTBplV0mz3NNclUnT3oBsupebOo1g
         PAHwsMT4uCEyItREWnFi6t/dUfyqFhZ1d3UV3HpY=
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        by smtp.codeaurora.org (Postfix) with ESMTP id 9570C60316;
        Fri,  8 Mar 2019 01:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=codeaurora.org;
        s=default; t=1552008514;
        bh=WaeaKJeULhzsi4TWI2pBOhZFiXwA0IGTmWyU7Rob840=;
        h=Date:From:To:Subject:From;
        b=FJIPVWIa97+UhdlrGm3hldd0/2tFcILMQC4RnAyJ8WfJNtqtYEfnDgYr79YYUrmg5
         aZJWqkuFB3iMrv2nAOTnIUsaicw1yVTjrSHHmiTBplV0mz3NNclUnT3oBsupebOo1g
         PAHwsMT4uCEyItREWnFi6t/dUfyqFhZ1d3UV3HpY=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 07 Mar 2019 18:28:34 -0700
From:   Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
To:     pablo@netfilter.org, netfilter-devel@vger.kernel.org
Subject: Backport of iptables TEE target fixes to 4.19
Message-ID: <8c2d25757db34ea82aef536d2337ef72@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.2.5
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo

We noticed that iptables TEE target is broken on 4.19 but are 
subsequently fixed now by -
18c0ab87364ac5128a152055fdcb1d27e01caf01 netfilter: xt_TEE: add missing 
code to get interface index in checkentry.
f24d2d4f9586985509320f90308723d3d0c4e47f netfilter: xt_TEE: fix wrong 
interface selection

Could these changes be pushed to 4.19 through linux-stable?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
a Linux Foundation Collaborative Project
