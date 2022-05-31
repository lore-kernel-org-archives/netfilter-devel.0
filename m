Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F3212C433F5
	for <netfilter-devel@archiver.kernel.org>; Tue, 31 May 2022 21:32:30 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345121AbiEaVca (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 31 May 2022 17:32:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344485AbiEaVc3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 31 May 2022 17:32:29 -0400
Received: from mail1.systemli.org (mail1.systemli.org [IPv6:2a11:7980:3::36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE8313526A
        for <netfilter-devel@vger.kernel.org>; Tue, 31 May 2022 14:32:26 -0700 (PDT)
Message-ID: <0e17882b-240a-f4f5-29ce-2afd17aa944b@systemli.org>
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=systemli.org;
        s=default; t=1654032740;
        bh=8FjvVYmLH2V5SedUJhb/EYjSdgv7oO4wEfzKf7lZJkQ=;
        h=Date:Subject:To:References:From:In-Reply-To:From;
        b=l+J3idA10UwPuzOxawyd3Iu4ONWpNd29F4lebAbdX73Fn84N8ASQnTO9bsYd3suOJ
         xvDzisMsoNxxsSu51xlRTrf3s0AyiYTZJlJ6L8pmmaOMkv4jlJEXl2YWiynrENodXn
         ohfJuyS8BkhaNQKLsD95J8HJbfZTBBqvHIm2v8tIMifgFpY5/k7DVq83n+RN3lulc8
         2GpQrVWA3pJ9TVFqg74ZWGMYZFodHM0JOXms+xLbpNLFER97S7Bjjl6t9sgSAb7m+E
         mOvcEkpobuYBbbITpNwcprmwlC6FGn8UyfO0F/JR4wzRV6Yvwijky1xGFYYVgVO5Bw
         I0ZX8xvTUk7GA==
Date:   Tue, 31 May 2022 23:32:00 +0200
MIME-Version: 1.0
Subject: Re: [PATCH] treewide: use uint* instead of u_int*
Content-Language: en-US
To:     Phil Sutter <phil@nwl.cc>, Jan Engelhardt <jengelh@inai.de>,
        netfilter-devel@vger.kernel.org
References: <9n33705n-4s4r-q4s1-q97-76n73p18s99r@vanv.qr>
 <20220516161641.15321-1-vincent@systemli.org>
 <YoNYjq2yDr3jbnyv@orbyte.nwl.cc> <r4s26683-61sq-8p27-o94-92rr8sqo796@vanv.qr>
 <YoTy4YCH1UjqmPAG@orbyte.nwl.cc>
From:   Nick <vincent@systemli.org>
In-Reply-To: <YoTy4YCH1UjqmPAG@orbyte.nwl.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Thanks for pushing. Sorry, for being absent.

On 5/18/22 15:21, Phil Sutter wrote:
> On Tue, May 17, 2022 at 10:14:10AM +0200, Jan Engelhardt wrote:
>> On Tuesday 2022-05-17 10:10, Phil Sutter wrote:
>>>> +++ b/include/libipq/libipq.h
>>>> -	u_int8_t blocking;
>>>> +	uint8_t blocking;
>>> Might this break API compatibility? ABI won't change, but I suppose
>>> users would have to include stdint.h prior to this header. Are we safe
>>> if we change the include from sys/types.h to stdint.h in line 27 of that
>>> file?
>> Always include what you use, so yeah, libipq.h should include stdint.h.
> Thanks. Patch pushed with the two changes I suggested.
>
> Thanks, Phil
