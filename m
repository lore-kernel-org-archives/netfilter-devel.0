Return-Path: <SRS0=IOUL=6E=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id ED33EC3815B
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 12:36:15 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id BF5692070B
	for <netfilter-devel@archiver.kernel.org>; Mon, 20 Apr 2020 12:36:15 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="lpNctCvZ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726562AbgDTMgP (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 20 Apr 2020 08:36:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726485AbgDTMgP (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 20 Apr 2020 08:36:15 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A895EC061A0F
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2020 05:36:14 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id k1so11953856wrx.4
        for <netfilter-devel@vger.kernel.org>; Mon, 20 Apr 2020 05:36:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Z4/xy7X3oWoDkDmPzaL2HQu2ZWDkC4ezmSq0koOpoUU=;
        b=lpNctCvZhLPQ7oWE28zFY9YMyuZxg5e02PVFaZmwoawTrrQvLMNR75kLG8SILESLaw
         oZErwoT3+C33OF+GnHvVH83e/88bI3G7A9kmoRc//pkDwRrAxoJTK8OkcKT9lAlTHm08
         zbav+sszB9lMt9Aqkc/BfeCR29GuTsxtmCIUKFctykWL0O6kgqslF7Fqb30udg3myfTh
         75J0t8EBXDX70iy1mlD8qbEwQpHIbggeyedN+rsAa/m868mXLMbpanlrHJ+UBgWfOngv
         tbVnDX/1O/VUrAqw3xQ/3uUJx7z54OPqZPAOOfI/iXQYrUEdgXVfDFpmFPi2P/R8V71c
         1alA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=Z4/xy7X3oWoDkDmPzaL2HQu2ZWDkC4ezmSq0koOpoUU=;
        b=VB62kPepShlxVC8seKXnvWfCNHyZq8LA3nVE4ys0HleW4VfORbcoyjO2Qa5YfjVgmM
         mAVXbt/5w0Un65aJn3WVHG9U1vLfuokYyLJIV1Iyvdu6Sh7y6sfkOFgkTHaJQghhb6Co
         suoOYhVBJb683RlMYI07MsvnLnaWMcQ+jhjhG1hE7tWYUsce156PIYX5d+N7a3FFfw0B
         aOnWV9/P71H90QeZXt9mcqpJ+H3orIyjvjsk353iiJNQe3SNPAHcY4AuIjdD3fL2mqcl
         WbkBx6p+/AhWQh/5RMiGZXrIgCM3VoUBU6ftY0jOY/dExKlPXAC0alkq/vG2nWhb0qta
         Dovg==
X-Gm-Message-State: AGi0Pua7Y2GzCOqHJ2teZXHBKdph7Ti5wywS3SWZqEkKYIBquWW7lSor
        kZjrzdPyV0pzrMLeteXkwTQxb+zhvbg=
X-Google-Smtp-Source: APiQypJO3jcZBO8lCs9ycTrA7xhamt5DaGgiDLW+xeG1nyRmUd/j1gm07DlJIFDkSY4CH2355g93Ag==
X-Received: by 2002:adf:f343:: with SMTP id e3mr17855249wrp.51.1587386173251;
        Mon, 20 Apr 2020 05:36:13 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id p7sm1024561wrf.31.2020.04.20.05.36.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 20 Apr 2020 05:36:12 -0700 (PDT)
Date:   Mon, 20 Apr 2020 14:36:11 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Edward Cree <ecree@solarflare.com>
Cc:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org
Subject: Re: [PATCH net] net: flow_offload: skip hw stats check for
 FLOW_ACTION_HW_STATS_DISABLED
Message-ID: <20200420123611.GF6581@nanopsycho.orion>
References: <20200419115338.659487-1-pablo@netfilter.org>
 <20200420080200.GA6581@nanopsycho.orion>
 <20200420090505.pr6wsunozfh7afaj@salvia>
 <20200420091302.GB6581@nanopsycho.orion>
 <20200420100341.6qehcgz66wq4ysax@salvia>
 <20200420115210.GE6581@nanopsycho.orion>
 <3980eea4-18d8-5e62-2d6d-fce0a7e7ed4c@solarflare.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <3980eea4-18d8-5e62-2d6d-fce0a7e7ed4c@solarflare.com>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Mon, Apr 20, 2020 at 02:28:22PM CEST, ecree@solarflare.com wrote:
>On 20/04/2020 12:52, Jiri Pirko wrote:
>> However for TC, when user specifies "HW_STATS_DISABLED", the driver
>> should not do stats.
>What should a driver do if the user specifies DISABLED, but the stats
> are still needed for internal bookkeeping (e.g. to prod an ARP entry
> that's in use for encapsulation offload, so that it doesn't get
> expired out of the cache)?  Enable the stats on the HW anyway but
> not report them to FLOW_CLS_STATS?  Or return an error?

If internally needed, it means they cannot be disabled. So returning
error would make sense, as what the user requested is not supported.


>
>-ed
