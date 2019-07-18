Return-Path: <SRS0=fTMW=VP=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id D28BAC76191
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 10:06:52 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id A686E21783
	for <netfilter-devel@archiver.kernel.org>; Thu, 18 Jul 2019 10:06:52 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="frx6QI7B"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733131AbfGRKGw (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 18 Jul 2019 06:06:52 -0400
Received: from mx1.riseup.net ([198.252.153.129]:35762 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726423AbfGRKGw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 18 Jul 2019 06:06:52 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 8F9CD1B93F9;
        Thu, 18 Jul 2019 03:06:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563444411; bh=pTpdYnJCAeypMCrVgIahYw2NlAZ6tGumAVrhQ49xB5E=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=frx6QI7BWIZMhriAFjOg8fFn+25RVZcLqzy7ClO8rePM76eFi1BnNPZmFCOcRBoFU
         dAPRENqgN21x6jhxnTBOt9mHPd/o2GK/4jrM+b9gQj+yoAyzNKVOCYx4mgRJwSMs92
         u17S7lU1zXljXGSMJrcy2iDCqLQhB9PbuJlYj/CQ=
X-Riseup-User-ID: 5E21EDD50966B7FCDBE3981AF2D6842E2506231514A748BB1E5BF6D3AEB649FC
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id 8FBCE2235D6;
        Thu, 18 Jul 2019 03:06:50 -0700 (PDT)
Subject: Re: [PATCH nft] include: json: add missing synproxy stmt print stub
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190718094114.28800-1-ffmancera@riseup.net>
 <20190718100130.ulbrtnk425rhigs5@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <6c9c3cb1-1b47-06ba-831d-b956c3fc4f98@riseup.net>
Date:   Thu, 18 Jul 2019 12:07:04 +0200
MIME-Version: 1.0
In-Reply-To: <20190718100130.ulbrtnk425rhigs5@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo,

On 7/18/19 12:01 PM, Pablo Neira Ayuso wrote:
> Hi Fernando,
> 
> On Thu, Jul 18, 2019 at 11:41:14AM +0200, Fernando Fernandez Mancera wrote:
>> Fixes: 1188a69604c3 ("src: introduce SYNPROXY matching")
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>> ---
>>  include/json.h | 1 +
>>  1 file changed, 1 insertion(+)
>>
>> diff --git a/include/json.h b/include/json.h
>> index ce57c9f..7f2df7c 100644
>> --- a/include/json.h
>> +++ b/include/json.h
>> @@ -180,6 +180,7 @@ STMT_PRINT_STUB(queue)
>>  STMT_PRINT_STUB(verdict)
>>  STMT_PRINT_STUB(connlimit)
>>  STMT_PRINT_STUB(tproxy)
>> +STMT_PRINT_STUB(synproxy)
> 
> I'm sure you need this, but how does this missing line manifests as a
> problem?
> 

When compiling nftables without json support I am getting the following
error.

statement.c:930:11: error: ‘synproxy_stmt_json’ undeclared here (not in
a function); did you mean ‘tproxy_stmt_json’?
  .json  = synproxy_stmt_json,
           ^~~~~~~~~~~~~~~~~~
           tproxy_stmt_json
