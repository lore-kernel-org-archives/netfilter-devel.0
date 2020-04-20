Return-Path: <SRS0=IOUL=6E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A6B71C54FCB
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 11:52:16 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 86172206D4
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 11:52:16 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="wqP7alfE"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgDTLwO (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 07:52:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53232 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725550AbgDTLwO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 07:52:14 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59BD0C061A0C
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2020 04:52:13 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id s10so2610663wrr.0
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2020 04:52:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=UYxy9FS5PYR9EgbXnicfhm0wcaLYtj6/Dul4Pg3CiCY=;
        b=wqP7alfEm47QGjHA80YD7YSibp45IGjJUvMwOLTFZ0IeO6W2luQinDj9w/dBfTP6Um
         yuHa799CntU6CMehhWmt8Xbajgh8+xUNfylyYHn0lIuY6+nrMVeNwAIRntC/0pIcIM2i
         quoHwChVUNaqKsgHckCaV8gY86s75uCsJCEI48l6haBm4mhfajH4dgVcFW0rObi4uEoM
         MCNOhWCsUNkqZZ3Aj5Jd5v5vEmok+xEgtvIQsiO6nSyCnHfyG12YW4I8J92So9Ogu5zf
         zlRAovoifD/o12zQSkkbIzT/wNkNEisJNaw7aOI4xqPUmCn1qrhLD3Ngjf2A5FaXWQHx
         QXig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=UYxy9FS5PYR9EgbXnicfhm0wcaLYtj6/Dul4Pg3CiCY=;
        b=k/uWdJ31OSVk+Hzu/f8X0NBGNsb39bkcGbNrjdvbOZfCVtYCMM30VN2o45vMk93OEu
         SVLyTrnP3Aj3Hio5fvBWp4KyM8NcrNZmPcfr/spB5DI4loCCyid1dahjGf13UjJj820o
         4OSRpf71K8Wv1sDF+RFMmvd2DzYNtxFNNF6jZn3jk+RqVwIaZQokq5WdmWdHiactjver
         Da0s5i5YqCniS6xNBg8HQW+cjsHbi24V/FnsoIq6PnKnZEC2w3Yu9Ex+5srb2+vx8Hti
         373auNh+IZCo2aW50nswm6Mx+51LfUbktxHZCZnDcxevv9CvTEFC1m3c+BYoP2/f7evv
         SViQ==
X-Gm-Message-State: AGi0PuaIpiRSpwVGqLC4j+PYaTaZGSJN7D/D2C5BSKXkaeEAsLipsFwM
        1rjvXBrpZ5LrENLU45+gu10fmA==
X-Google-Smtp-Source: APiQypKNC9G93tvWAr9x9+pmgGXHn898FVrnFsGdG7240K5F0Zw5rPWf3ZPBR6njNOSnI5COMyPmoA==
X-Received: by 2002:adf:e84f:: with SMTP id d15mr11795239wrn.296.1587383532122;
        Mon, 20 Apr 2020 04:52:12 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id r3sm958862wrx.72.2020.04.20.04.52.10
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 04:52:11 -0700 (PDT)
Date:   Mon, 20 Apr 2020 13:52:10 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
Message-ID: <20200420115210.GE6581@nanopsycho.orion>
References: <20200419115338.659487-1-pablo@netfilter.org>
 <20200420080200.GA6581@nanopsycho.orion>
 <20200420090505.pr6wsunozfh7afaj@salvia>
 <20200420091302.GB6581@nanopsycho.orion>
 <20200420100341.6qehcgz66wq4ysax@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200420100341.6qehcgz66wq4ysax@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mon, Apr 20, 2020 at 12:03:41PM CEST, pablo@netfilter.org wrote:
>On Mon, Apr 20, 2020 at 11:13:02AM +0200, Jiri Pirko wrote:
>> Mon, Apr 20, 2020 at 11:05:05AM CEST, pablo@netfilter.org wrote:
>> >On Mon, Apr 20, 2020 at 10:02:00AM +0200, Jiri Pirko wrote:
>> >> Sun, Apr 19, 2020 at 01:53:38PM CEST, pablo@netfilter.org wrote:
>> >> >If the frontend requests no stats through FLOW_ACTION_HW_STATS_DISABLED,
>> >> >drivers that are checking for the hw stats configuration bail out with
>> >> >EOPNOTSUPP.
>> >>
>> >> Wait, that was a point. Driver has to support stats disabling.
>> >
>> >Hm, some drivers used to accept FLOW_ACTION_HW_STATS_DISABLED, now
>> >rulesets that used to work don't work anymore.
>>
>> How? This check is here since the introduction of hw stats types.
>
>Netfilter is setting the counter support to
>FLOW_ACTION_HW_STATS_DISABLED in this example below:
>
>  table netdev filter {
>        chain ingress {
>                type filter hook ingress device eth0 priority 0; flags offload;
>
>                tcp dport 22 drop
>        }
>  }

Hmm. In TC the HW_STATS_DISABLED has to be explicitly asked by the user,
as the sw stats are always on. Your case is different.
However so far (before HW_STATS patchset), the offload just did the
stats and you ignored them in netfilter code, correct?

Perhaps we need another value of this, like "HW_STATS_MAY_DISABLED" for
such case. Because you don't care if the HW actually does the stats or
not. It is an optimization for you.

However for TC, when user specifies "HW_STATS_DISABLED", the driver
should not do stats.


>
>The user did not specify a counter in this case.
>
>I think __flow_action_hw_stats_check() cannot work with
>FLOW_ACTION_HW_STATS_DISABLED.
>
>If check_allow_bit is false and FLOW_ACTION_HW_STATS_DISABLED is
>specified, then this always evaluates true:
>
>        if (!check_allow_bit &&
>            action_entry->hw_stats != FLOW_ACTION_HW_STATS_ANY) {
>
>Similarly:
>
>        } else if (check_allow_bit &&
>                   !(action_entry->hw_stats & BIT(allow_bit))) {
>
>evaluates true for FLOW_ACTION_HW_STATS_DISABLED, assuming allow_bit is
>set, which I think it is the intention.

That is correct. __flow_action_hw_stats_check() helper is here for
simple drivers that support just one type of hw stats
(immediate/delayed).


>
>Another suggestion: This is control plane code and this
>__flow_action_hw_stats_check() function is relatively large, I'd suggest
>to move it to net/core/flow_offload.c at some point.

Sure, why not.


>
>Thank you!
