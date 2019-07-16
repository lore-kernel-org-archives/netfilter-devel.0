Return-Path: <SRS0=/Fuh=VN=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 9F93EC7618F
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 22:42:39 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 65E682173E
	for <netfilter-devel@archiver.kernel.org>; Tue, 16 Jul 2019 22:42:39 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="qz4kIabj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388711AbfGPWmj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 16 Jul 2019 18:42:39 -0400
Received: from mx1.riseup.net ([198.252.153.129]:47316 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728235AbfGPWmi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 16 Jul 2019 18:42:38 -0400
Received: from bell.riseup.net (bell-pn.riseup.net [10.0.1.178])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id C397C1A6696;
        Tue, 16 Jul 2019 15:42:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563316957; bh=BDsjHnryZeKAXRtKkDifbexGthjxy6/i3djYNd84Eww=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=qz4kIabjIcvyMmpD/SYm8MtqNK/E42FKMUv6lgLhKv3PfIL1J6pI2cozlohDLYahF
         XSsiwwzuj9hRolzDc8WLOc6VqNp0rPLNMwhSUzk5M5ABpJQgHcr2MGlpRBLy4cDAo0
         i9a4QFU/+V39/XHrQ+ABLicAv2s6K8GNQEzG+bW8=
X-Riseup-User-ID: 5228834F011F8743D6465485F6B948A2C394CB2F457745C6BB98ACFFCF94DFBD
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by bell.riseup.net (Postfix) with ESMTPSA id C16E722307B;
        Tue, 16 Jul 2019 15:42:36 -0700 (PDT)
Subject: Re: [PATCH 1/2 nft WIP] src: introduce prio_expr in chain priority
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org
References: <20190716090812.873-1-ffmancera@riseup.net>
 <20190716090812.873-2-ffmancera@riseup.net>
 <20190716180646.ajihkibvox4nkd2c@salvia>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <a1c9efde-fe86-028c-73cd-546a34143fbd@riseup.net>
Date:   Wed, 17 Jul 2019 00:42:49 +0200
MIME-Version: 1.0
In-Reply-To: <20190716180646.ajihkibvox4nkd2c@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Pablo, thanks for reviewing. Comments below.

On 7/16/19 8:06 PM, Pablo Neira Ayuso wrote:
> On Tue, Jul 16, 2019 at 11:08:12AM +0200, Fernando Fernandez Mancera wrote:
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>> ---
>>  include/rule.h     |  8 ++++----
>>  src/evaluate.c     | 29 +++++++++++++++++++----------
>>  src/parser_bison.y | 25 +++++++++++++++++--------
>>  src/rule.c         |  4 ++--
>>  4 files changed, 42 insertions(+), 24 deletions(-)
>>
>> diff --git a/include/rule.h b/include/rule.h
>> index aefb24d..4d7cec8 100644
>> --- a/include/rule.h
>> +++ b/include/rule.h
>> @@ -173,13 +173,13 @@ enum chain_flags {
>>   * struct prio_spec - extendend priority specification for mixed
>>   *                    textual/numerical parsing.
>>   *
>> - * @str:  name of the standard priority value
>> - * @num:  Numerical value. This MUST contain the parsed value of str after
>> + * @prio_expr:  expr of the standard priority value
>> + * @num:  Numerical value. This MUST contain the parsed value of prio_expr after
>>   *        evaluation.
>>   */
>>  struct prio_spec {
>> -	const char  *str;
>> -	int          num;
>> +	struct expr	*prio_expr;
> 
> Use:
> 
>         struct expr     *expr;
> 
> instead.
> 
>> +	int		num;
> 
> You could just store this in the expression, no need for this num
> field.
> 

I think that would not be possible. Right now, the priority
specification supports combinations of a string and a number. e.g

table inet global {
    chain prerouting {
        type filter hook prerouting priority filter + 3
        policy accept
    }
}

or

table inet global {
    chain prerouting {
        type filter hook prerouting priority filter - 3
        policy accept
    }
}

I don't think we are going to be able to do that using only a single
"struct expr *".

>>  	struct location loc;
>>  };
>>  
>> diff --git a/src/evaluate.c b/src/evaluate.c
>> index 8086f75..cee65cd 100644
>> --- a/src/evaluate.c
>> +++ b/src/evaluate.c
>> @@ -3181,15 +3181,24 @@ static int set_evaluate(struct eval_ctx *ctx, struct set *set)
>>  	return 0;
>>  }
>>  
>> -static bool evaluate_priority(struct prio_spec *prio, int family, int hook)
>> +static bool evaluate_priority(struct eval_ctx *ctx, struct prio_spec *prio,
>> +			      int family, int hook)
>>  {
>>  	int priority;
>> +	char prio_str[NFT_NAME_MAXLEN];
>>  
>>  	/* A numeric value has been used to specify priority. */
>> -	if (prio->str == NULL)
>> +	if (prio->prio_expr == NULL)
> 
> prio_expr == NULL never happens.
> 

It never happens if we only have a single field in the "struct prio_spec".

Thanks!
