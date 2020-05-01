Return-Path: <SRS0=Z556=6P=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-3.5 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 17121C35280
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 19:59:51 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 365C82073E
	for <netfilter-devel@archiver.kernel.org>; Fri,  1 May 2020 19:59:50 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=fami-braun.de header.i=@fami-braun.de header.b="jvtqB2So"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727804AbgEAT7u (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 1 May 2020 15:59:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726377AbgEAT7t (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 1 May 2020 15:59:49 -0400
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::12])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41F70C061A0C
        for <netfilter-devel@vger.kernel.org>; Fri,  1 May 2020 12:59:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588363186;
        s=strato-dkim-0002; d=fami-braun.de;
        h=Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=l6XrhkT3tVJqJAVram6GA8Z9/KF0c5rTx++yMSW7ZG8=;
        b=jvtqB2SoLFhUcWGNSK785DlCV46jvtTb/whxHQdjQDf5ZuQ9ecwXl1lQULFmzWr+yQ
        fz5YdOCCyoNOAiMeGy9bMRodi5Q0uBURfp4Ve1RyLBuzogtLygaHgTaIz6YozQHjKdtQ
        prBKgTOtLJuSFEpdc/yUR3AGbZjkw7lEsPF4uE/Cj3zy4VB5V+tjcng418tQ2dKT736u
        9Y/yUDyqCLuLYw2zJSJ4owX/XcjFTfusK+Tn4cq1kkhAYuFEkdFPbzbneD8MjfczuHpK
        CCqk9tyGj0B89jRzHtPT8WiTgRbRLhM0HsSFJtuLz9fG6pVwKBOfntvd+en+3EpUky2j
        uqMg==
X-RZG-AUTH: ":P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBEm4ljegySSvO7VhbcRIBGrxpcA5nVfJ6oTd1q4i2uxsHZDcOZOyRtXiWS1M+sofvL3FwLO88jA=="
X-RZG-CLASS-ID: mo00
Received: from dynamic.fami-braun.de
        by smtp.strato.de (RZmta 46.6.2 AUTH)
        with ESMTPSA id g05fffw41JxjjJZ
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 1 May 2020 21:59:45 +0200 (CEST)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id 58A4315414C;
        Fri,  1 May 2020 21:59:45 +0200 (CEST)
Received: from ac/DyQ6jpJ2+t0J6UA8xU6ZlPgbLJMOlsKiKJXl78VR4FAx13uXgyA==
 (rGXyzjDPG2gWuE2JDVrDLuPQcv0FzBEB)
 by webmail.fami-braun.de
 with HTTP (HTTP/1.1 POST); Fri, 01 May 2020 21:59:35 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 01 May 2020 21:59:35 +0200
From:   michael-dev <michael-dev@fami-braun.de>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 3/3] datatype: fix double-free resulting in use-after-free
 in datatype_free
In-Reply-To: <20200501192703.GC13722@salvia>
References: <20200501154819.2984-1-michael-dev@fami-braun.de>
 <20200501154819.2984-3-michael-dev@fami-braun.de>
 <20200501192703.GC13722@salvia>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <545922fa020689faa17dae656320fe58@fami-braun.de>
X-Sender: michael-dev@fami-braun.de
X-Virus-Scanned: clamav-milter 0.102.2 at gate
X-Virus-Status: Clean
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Am 01.05.2020 21:27, schrieb Pablo Neira Ayuso:
> On Fri, May 01, 2020 at 05:48:18PM +0200, Michael Braun wrote:
>> +	if (dtype == expr->dtype)
>> +		return; // do not free dtype before incrementing refcnt again
> 
> The problem you describe (use-after-free) happens in this case, right?

The problem is more likely due to concat_expr_parse_udata not calling 
datatype_get,
because otherwise datatype_get would be in the backtrace of ASAN.

> 
>         datatype_set(expr, expr->dtype);
> 
> Or am I missing anything?

But while debugging the above output, I added assert(dtype != 
expr->dtype) here
and that crashed. So I'm sure something like this is happening.
And the whole thing was nasty to debug, so I added this one just be sure 
it does not happen again.

As ASAN should hit on datatype_get incrementing refcnt if datatype_free 
had actually freed it,
assert was probaby not seeing an DTYPE_F_ALLOC instance.
But I dig not deeper here, as I felt this return is safe to add.

> 
>>  	datatype_free(expr->dtype);
>>  	expr->dtype = datatype_get(dtype);
>>  }
>> diff --git a/src/expression.c b/src/expression.c
>> index 6605beb3..a6bde70f 100644
>> --- a/src/expression.c
>> +++ b/src/expression.c
>> @@ -955,7 +955,7 @@ static struct expr *concat_expr_parse_udata(const 
>> struct nftnl_udata *attr)
>>  	if (!dtype)
>>  		goto err_free;
>> 
>> -	concat_expr->dtype = dtype;
>> +	concat_expr->dtype = datatype_get(dtype);
> 
> This is also good indeed.

This is what caused the ASAN output above to go away.

Regards,
M. Braun
