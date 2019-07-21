Return-Path: <SRS0=p03Y=VS=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-6.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SIGNED_OFF_BY,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id EF4BCC76188
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 09:59:06 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 981E42084C
	for <netfilter-devel@archiver.kernel.org>; Sun, 21 Jul 2019 09:59:06 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=riseup.net header.i=@riseup.net header.b="JK+HAdbP"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726156AbfGUJ7G (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 21 Jul 2019 05:59:06 -0400
Received: from mx1.riseup.net ([198.252.153.129]:59944 "EHLO mx1.riseup.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726019AbfGUJ7G (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 21 Jul 2019 05:59:06 -0400
Received: from capuchin.riseup.net (capuchin-pn.riseup.net [10.0.1.176])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (Client CN "*.riseup.net", Issuer "COMODO RSA Domain Validation Secure Server CA" (verified OK))
        by mx1.riseup.net (Postfix) with ESMTPS id 301A21A06D9;
        Sun, 21 Jul 2019 02:59:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=riseup.net; s=squak;
        t=1563703145; bh=HYiCT47sYNbG+XKP96gIumNFO0R8H3uxyT19vLzp2jA=;
        h=Subject:To:References:Cc:From:Date:In-Reply-To:From;
        b=JK+HAdbP+hLupO5ynL8Plc9+p1RmgFHhSpywM6J+DsJ74/S4OLIlAbHjRfAn2mKXQ
         V709KsA9NSn4Fw57xHi6OAsA4dCaUABy+UQe0tj0PKj6o7QFMiYwkhbNiPZeV89EEA
         KEqvtv8hsJeC3aOeljbNDogrlOlPwQ4TUJ7Uh1iI=
X-Riseup-User-ID: 868CE6E5A6EBB15F7AB4931B928D2B1B1DF68ABEED2DCB5DD0ABE4B9E5A30234
Received: from [127.0.0.1] (localhost [127.0.0.1])
         by capuchin.riseup.net (Postfix) with ESMTPSA id 834D1120390;
        Sun, 21 Jul 2019 02:59:03 -0700 (PDT)
Subject: Re: [PATCH nft] src: osf: fix snprintf -Wformat-truncation warning
To:     Phil Sutter <phil@nwl.cc>
References: <20190718110145.13361-1-ffmancera@riseup.net>
 <20190720202157.GB22661@orbyte.nwl.cc>
Cc:     netfilter-devel@vger.kernel.org, Florian Westphal <fw@strlen.de>
From:   Fernando Fernandez Mancera <ffmancera@riseup.net>
Openpgp: preference=signencrypt
Message-ID: <00a4ebbb-a571-b00a-83ac-ad198ccbd263@riseup.net>
Date:   Sun, 21 Jul 2019 11:59:14 +0200
MIME-Version: 1.0
In-Reply-To: <20190720202157.GB22661@orbyte.nwl.cc>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US-large
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi Phil,

On 7/20/19 10:21 PM, Phil Sutter wrote:
> Hi Fernando,
> 
> On Thu, Jul 18, 2019 at 01:01:46PM +0200, Fernando Fernandez Mancera wrote:
>> Fedora 30 uses very recent gcc (version 9.1.1 20190503 (Red Hat 9.1.1-1)),
>> osf produces following warnings:
>>
>> -Wformat-truncation warning have been introduced in the version 7.1 of gcc.
>> Also, remove a unneeded address check of "tmp + 1" in nf_osf_strchr().
>>
>> nfnl_osf.c: In function ‘nfnl_osf_load_fingerprints’:
>> nfnl_osf.c:292:39: warning: ‘%s’ directive output may be truncated writing
>> up to 1023 bytes into a region of size 128 [-Wformat-truncation=]
>>   292 |   cnt = snprintf(obuf, sizeof(obuf), "%s,", pbeg);
>>       |                                       ^~
>> nfnl_osf.c:292:9: note: ‘snprintf’ output between 2 and 1025 bytes into a
>> destination of size 128
>>   292 |   cnt = snprintf(obuf, sizeof(obuf), "%s,", pbeg);
>>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> nfnl_osf.c:302:46: warning: ‘%s’ directive output may be truncated writing
>> up to 1023 bytes into a region of size 32 [-Wformat-truncation=]
>>   302 |    cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg);
>>       |                                              ^~
>> nfnl_osf.c:302:10: note: ‘snprintf’ output between 1 and 1024 bytes into a
>> destination of size 32
>>   302 |    cnt = snprintf(f.genre, sizeof(f.genre), "%s", pbeg);
>>       |          ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> nfnl_osf.c:309:49: warning: ‘%s’ directive output may be truncated writing
>> up to 1023 bytes into a region of size 32 [-Wformat-truncation=]
>>   309 |   cnt = snprintf(f.version, sizeof(f.version), "%s", pbeg);
>>       |                                                 ^~
>> nfnl_osf.c:309:9: note: ‘snprintf’ output between 1 and 1024 bytes into a
>> destination of size 32
>>   309 |   cnt = snprintf(f.version, sizeof(f.version), "%s", pbeg);
>>       |         ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>> nfnl_osf.c:317:47: warning: ‘%s’ directive output may be truncated writing
>> up to 1023 bytes into a region of size 32 [-Wformat-truncation=]
>>   317 |       snprintf(f.subtype, sizeof(f.subtype), "%s", pbeg);
>>       |                                               ^~
>> nfnl_osf.c:317:7: note: ‘snprintf’ output between 1 and 1024 bytes into a
>> destination of size 32
>>   317 |       snprintf(f.subtype, sizeof(f.subtype), "%s", pbeg);
>>       |       ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
>>
>> Reported-by: Florian Westphal <fw@strlen.de>
>> Signed-off-by: Fernando Fernandez Mancera <ffmancera@riseup.net>
>> ---
>>  src/nfnl_osf.c | 14 +++++++-------
>>  1 file changed, 7 insertions(+), 7 deletions(-)
>>
>> diff --git a/src/nfnl_osf.c b/src/nfnl_osf.c
>> index be3fd81..c99f8f3 100644
>> --- a/src/nfnl_osf.c
>> +++ b/src/nfnl_osf.c
>> @@ -81,7 +81,7 @@ static char *nf_osf_strchr(char *ptr, char c)
>>  	if (tmp)
>>  		*tmp = '\0';
>>  
>> -	while (tmp && tmp + 1 && isspace(*(tmp + 1)))
>> +	while (tmp && isspace(*(tmp + 1)))
>>  		tmp++;
>>  
>>  	return tmp;
>> @@ -212,7 +212,7 @@ static int osf_load_line(char *buffer, int len, int del,
>>  			 struct netlink_ctx *ctx)
>>  {
>>  	int i, cnt = 0;
>> -	char obuf[MAXOPTSTRLEN];
>> +	char obuf[MAXOPTSTRLEN + 1];
>>  	struct nf_osf_user_finger f;
>>  	char *pbeg, *pend;
>>  	struct nlmsghdr *nlh;
>> @@ -289,7 +289,7 @@ static int osf_load_line(char *buffer, int len, int del,
>>  	pend = nf_osf_strchr(pbeg, OSFPDEL);
>>  	if (pend) {
>>  		*pend = '\0';
>> -		cnt = snprintf(obuf, sizeof(obuf), "%s,", pbeg);
>> +		cnt = snprintf(obuf, sizeof(obuf), "%.128s", pbeg);
> 
> Not a big deal, but sizeof() and hard-coding the "precision" doesn't mix
> well in my opinion. I've solved this like so:
> 
> 		i = sizeof(obuf);
> 		cnt = snprintf(obuf, i, "%.*s,", i - 2, pbeg);
> 
> (i - 2) to leave space for the trailing comma and nul-char. Also note
> that your patch drops the trailing comma, I guess that's a bug.
> 

Oh! I am really happy that you spotted the missing trailing comma,
thanks! :-)

> Maybe you want to have a look at my patch (Message-ID
> 20190720185226.8876-2-phil@nwl.cc) and incorporate what's useful into
> yours? It's your code, so you should know better how to fix things. :)
> 
> Thanks, Phil
> 

I think your code is more readable than mine. I am going to send a v2
patch with your code but also adding the following fix.

-	while (tmp && tmp + 1 && isspace(*(tmp + 1)))
+	while (tmp && isspace(*(tmp + 1)))

I am going to send a similar patch for the iptables tree because this
file was imported from iptables.git/utils/nfnl_osf.c.

Thanks!
