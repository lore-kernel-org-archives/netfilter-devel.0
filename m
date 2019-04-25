Return-Path: <SRS0=ai/f=S3=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.1 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_PASS
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B3F01C43218
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 15:41:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id C3F842088F
	for <netfilter-devel@archiver.kernel.org>; Thu, 25 Apr 2019 15:41:49 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=6wind.com header.i=@6wind.com header.b="cQ18ZlCz"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727218AbfDYPlt (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 25 Apr 2019 11:41:49 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:41925 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726058AbfDYPls (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 25 Apr 2019 11:41:48 -0400
Received: by mail-wr1-f67.google.com with SMTP id c12so60674wrt.8
        for <netfilter-devel@vger.kernel.org>; Thu, 25 Apr 2019 08:41:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=reply-to:subject:from:to:cc:references:organization:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=7/FOxH44YK0IXS/xPrKWOn7zKzhA8URyjbm5SJIfXPs=;
        b=cQ18ZlCzQQ3Z6k8+9uvkH88C+KcXtaWU+Hcf/yqhxRYKrCRixroYY+KEALZJJz5/bp
         Up31A+S13FxqEXI4JyZHzYs+uWqO5ZF4nyxaPK98sP/Gk1NYk3ZNlgAzjKY49KysqHqb
         2ElZL43ri7h71aJ9RZMv7ySOPBIQuZoGP+gu0CdlNVODaYmDnejXreB6b1OeAJahkQnJ
         vrmHFWMLepEIsmakBVlkUEoDaOnb6Ft8CXu/oni/UpBo9xyqU6kInCrfoSTIV28jyXVE
         TrBsFJobSiu3ZJLBtCy1Ga+EYewTiolM2qDX68ERNCB98ykmJTQTyZ9Ikn94kMYwkYoO
         Ou+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:reply-to:subject:from:to:cc:references
         :organization:message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=7/FOxH44YK0IXS/xPrKWOn7zKzhA8URyjbm5SJIfXPs=;
        b=nhE2zJJhwZowJwD8eJHYvSNq9wboXJ2IhwoyOydo/+akSYjJngUvQYnbnWz6wZm/Bq
         LRniSb1cX5k2AZ0Cb/QQJsYsodQywwBADfZZUgQgqpp9j32xDQvqhjlOEBvGs3Sdj7a4
         cG2cu/J/1ypEsnHlpCeX6pcnSJ5dt0mYQU7I4azKCej77r1Ul8jibHe9hUurCY1P/Gja
         kPSF/0rND9j5n9xLxLWuqdYCw0wF0JB4mV52xMgDR/GXo8nIUQNDuR6n6n8oI9DT9Fuv
         MZ1chlHqs+oeWtn5/RqbgBx+1kRySMyqqmbUiO3lcaX/cVCMC0aAtaQP7TXxhw97ESi1
         mj3A==
X-Gm-Message-State: APjAAAXOwty3m2pqe0DStZjOMoSw5WfuCbuzUP+X44eXC9cKHex8PKWJ
        yd8FGE6hjrhZ1lwn8CTyFtxzzw==
X-Google-Smtp-Source: APXvYqxGh6xu/gPoj2GZYbtatvCKMYMG+18sJ6mVJDDMqNdS1dptiMXU9an2v8sUsOoVeQaGI8vQpw==
X-Received: by 2002:a05:6000:10cc:: with SMTP id b12mr1278640wrx.182.1556206906968;
        Thu, 25 Apr 2019 08:41:46 -0700 (PDT)
Received: from ?IPv6:2a01:e35:8b63:dc30:d4c0:843b:d436:a905? ([2a01:e35:8b63:dc30:d4c0:843b:d436:a905])
        by smtp.gmail.com with ESMTPSA id w12sm54024182wrg.29.2019.04.25.08.41.45
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Thu, 25 Apr 2019 08:41:46 -0700 (PDT)
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH 07/31] netfilter: ctnetlink: Support L3 protocol-filter on
 flush
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org,
        Kristian Evensen <kristian.evensen@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
References: <20181008230125.2330-1-pablo@netfilter.org>
 <20181008230125.2330-8-pablo@netfilter.org>
 <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
Organization: 6WIND
Message-ID: <09d0cd50-b64d-72c3-0aa1-82eb461bfa19@6wind.com>
Date:   Thu, 25 Apr 2019 17:41:45 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
MIME-Version: 1.0
In-Reply-To: <33d60747-7550-1fba-a068-9b78aaedbc26@6wind.com>
Content-Type: text/plain; charset=utf-8
Content-Language: fr
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Le 25/04/2019 à 12:07, Nicolas Dichtel a écrit :
[snip]
> In fact, the conntrack tool set by default the family to AF_INET and forbid to
> set the family to something else (the '-f' option is not allowed for the command
> 'flush').
'conntrack -D -f ipv6' will do the job, but this is still a regression.


Regards,
Nicolas
