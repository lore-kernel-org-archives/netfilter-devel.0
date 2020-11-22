Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-8.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 59847C5519F
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 19:56:05 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 0F5F42075A
	for <netfilter-devel@archiver.kernel.org>; Sun, 22 Nov 2020 19:56:04 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="pO1J9ccj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727757AbgKVTza (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 22 Nov 2020 14:55:30 -0500
Received: from m42-4.mailgun.net ([69.72.42.4]:18785 "EHLO m42-4.mailgun.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727370AbgKVTz3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 22 Nov 2020 14:55:29 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1606074929; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=+Rcg0+sBXUFNeuyp40r/FoFC9yRzFcPNdejGpYm+AQg=;
 b=pO1J9ccjwEzlo6qGTdOYOAFsn2ADMiSd3SAVBtnbcDA339htgPPau/zerk39NklPmFa/qTX0
 jC609j9PDfHlcRfqVV4ZWhXsrLALz1xOeKLoNIQKaIBAH9OVHM9M9HyQcShmSbIKSvbvYNqU
 4IfH2Ykw++UF7pt0PZQGcg75nL4=
X-Mailgun-Sending-Ip: 69.72.42.4
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n05.prod.us-west-2.postgun.com with SMTP id
 5fbac2307ef0a8d8431b5455 (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Sun, 22 Nov 2020 19:55:28
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 8F3C4C43460; Sun, 22 Nov 2020 19:55:28 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 48736C433C6;
        Sun, 22 Nov 2020 19:55:26 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Sun, 22 Nov 2020 12:55:26 -0700
From:   subashab@codeaurora.org
To:     Florian Westphal <fw@strlen.de>
Cc:     will@kernel.org, pablo@netfilter.org, stranche@codeaurora.org,
        netfilter-devel@vger.kernel.org, tglx@linutronix.de,
        peterz@infradead.org
Subject: Re: [PATCH nf] netfilter: x_tables: Switch synchronization to RCU
In-Reply-To: <20201122193537.GV15137@breakpoint.cc>
References: <1606072636-23555-1-git-send-email-subashab@codeaurora.org>
 <20201122193537.GV15137@breakpoint.cc>
Message-ID: <849b3bf0b35edf5ba1b23636a4b57ba6@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2020-11-22 12:35, Florian Westphal wrote:
> Subash Abhinov Kasiviswanathan <subashab@codeaurora.org> wrote:
>> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
>> index af22dbe..416a617 100644
>> --- a/net/netfilter/x_tables.c
>> +++ b/net/netfilter/x_tables.c
>> @@ -1349,6 +1349,14 @@ struct xt_counters *xt_counters_alloc(unsigned 
>> int counters)
>>  }
>>  EXPORT_SYMBOL(xt_counters_alloc);
> [..]
> 
>>  	/* Do the substitution. */
>> -	local_bh_disable();
>> -	private = table->private;
>> +	private = xt_table_get_private_protected(table);
>> 
>>  	/* Check inside lock: is the old number correct? */
>>  	if (num_counters != private->number) {
> 
> There is a local_bh_enable() here that needs removal.

Thanks, will update that.

diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
index 416a617..acce622 100644
--- a/net/netfilter/x_tables.c
+++ b/net/netfilter/x_tables.c
@@ -1379,7 +1379,6 @@ xt_replace_table(struct xt_table *table,
         if (num_counters != private->number) {
                 pr_debug("num_counters != table->private->number 
(%u/%u)\n",
                          num_counters, private->number);
-               local_bh_enable();
                 *error = -EAGAIN;
                 return NULL;
         }

> 
> Did you test it with PROVE_LOCKING enabled?
> 
> The placement/use of rcu_dereference and the _protected version
> looks correct, I would not expect splats.

My config doesn't seem to have it. I will enable and try it out.
