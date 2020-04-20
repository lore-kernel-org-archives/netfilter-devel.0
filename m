Return-Path: <SRS0=IOUL=6E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A5C31C54FCB
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 13:48:33 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 8615D20735
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 13:48:33 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="ir2H+e8N"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728894AbgDTNsc (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 09:48:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728321AbgDTNs3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 09:48:29 -0400
Received: from mail-wr1-x444.google.com (mail-wr1-x444.google.com [IPv6:2a00:1450:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34D3CC061A0C
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2020 06:48:29 -0700 (PDT)
Received: by mail-wr1-x444.google.com with SMTP id g13so10216202wrb.8
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2020 06:48:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=imtZsjSmtZ9lToO+D+hdQXHxKttVZf90A06FjfqjHgc=;
        b=ir2H+e8NqatcbEggL19HMjCjkGRk5EAGvdNVTcSDsBYhlzFb5AuMXzUBL5z0VGkZDz
         b/XYHADkstcPUaN5RIpw8+RNcM1oT7JXTRz5leG2xSMa1t+qT3Dfww+3kOyhfoSCQzLr
         WFinwdmyeVE3/o4dsJX8bds420Y37JxZKH50WbT5AKulAe+VsURWfJJZDy6Pc79v4Xk/
         M3RI5Th47urxvir4Y1cP07LQQsvr8fTGgDEMU+f9MkbzTx+qm5gM44YFVAEcpgFNh9po
         2wquc7+1a4Kgd2uNhmprCKNeUReCjnXONX743OS9bR7wksm8NW2I1I8oZsHSTjfCX2y7
         1kfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=imtZsjSmtZ9lToO+D+hdQXHxKttVZf90A06FjfqjHgc=;
        b=HBqkOVEFsgXjOWHynvp/fX2Cru/8Fhq+vIo+f1xOhzG1S2r+HEz9IbaLn2rPjBs35v
         KEhnWKQDo28IQAksyk8p6E0fhWzS2CcfpEjnhBbfqonnNHvuQEdvBJUBv+Bicn8cUfZz
         7oPo6UiwBWmFyM6/bWtlNqyGJPWvLIvGVKsfIGCf3CRDkN+i5gE+oXTe0LuBe3KCtEIr
         WovIrJGIWIdjV/lkneGTrfcO6FqZWdTW62ejFYHNyDlqN8gr2WI77swbjASp2mF88UbX
         MpdlfqQTfTnpRojyTETMmcBa4AM4GpwG4diUtAwFLBsQCshMFU0LLb3r/1CA79mnX+cy
         k0OA==
X-Gm-Message-State: AGi0Puarr+JogGHY8YUx0iR6djn4OTnRPp0fy2hNUqMjj73rigAvp9Cw
        YgLzhV+HYMdkF9mp/PUohWrcCg==
X-Google-Smtp-Source: APiQypJ4sFE3+IEwO4LkKimwzsi0HGaG8Tciw6b3yX+IEtQkIQ/+CuCOb2yn4iZQrYtHx0zbIfWmXQ==
X-Received: by 2002:a5d:4712:: with SMTP id y18mr19261460wrq.306.1587390508020;
        Mon, 20 Apr 2020 06:48:28 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id i17sm1264756wru.39.2020.04.20.06.48.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 06:48:27 -0700 (PDT)
Date:   Mon, 20 Apr 2020 15:48:26 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     Edward Cree <ecree@solarflare.com>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
Message-ID: <20200420134826.GH6581@nanopsycho.orion>
References: <20200419115338.659487-1-pablo@netfilter.org>
 <20200420080200.GA6581@nanopsycho.orion>
 <20200420090505.pr6wsunozfh7afaj@salvia>
 <20200420091302.GB6581@nanopsycho.orion>
 <20200420100341.6qehcgz66wq4ysax@salvia>
 <20200420115210.GE6581@nanopsycho.orion>
 <3980eea4-18d8-5e62-2d6d-fce0a7e7ed4c@solarflare.com>
 <20200420123915.nrqancwjb7226l7e@salvia>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200420123915.nrqancwjb7226l7e@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mon, Apr 20, 2020 at 02:39:15PM CEST, pablo@netfilter.org wrote:
>On Mon, Apr 20, 2020 at 01:28:22PM +0100, Edward Cree wrote:
>> On 20/04/2020 12:52, Jiri Pirko wrote:
>> > However for TC, when user specifies "HW_STATS_DISABLED", the driver
>> > should not do stats.
>>
>> What should a driver do if the user specifies DISABLED, but the stats
>>  are still needed for internal bookkeeping (e.g. to prod an ARP entry
>>  that's in use for encapsulation offload, so that it doesn't get
>>  expired out of the cache)?  Enable the stats on the HW anyway but
>>  not report them to FLOW_CLS_STATS?  Or return an error?
>
>My interpretation is that HW_STATS_DISABLED means that the front-end
>does not care / does not need counters. The driver can still allocate

That is wrong interpretation. If user does not care, he specifies "ANY".
That is the default.

When he says "DISABLED" he means disabled. Not "I don't care".


>them if needed. So the enum flow_action_hw_stats flags represent what
>the front-end requires.
