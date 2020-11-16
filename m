Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-11.8 required=3.0 tests=BAYES_00,DKIM_SIGNED,
	DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_PATCH,MAILING_LIST_MULTI,
	MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id F2F56C4742C
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 16:26:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id B270720DD4
	for <netfilter-devel@archiver.kernel.org>; Mon, 16 Nov 2020 16:26:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (1024-bit key) header.d=mg.codeaurora.org header.i=@mg.codeaurora.org header.b="aacT05LQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732090AbgKPQ0K (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 16 Nov 2020 11:26:10 -0500
Received: from z5.mailgun.us ([104.130.96.5]:29265 "EHLO z5.mailgun.us"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732089AbgKPQ0K (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 16 Nov 2020 11:26:10 -0500
DKIM-Signature: a=rsa-sha256; v=1; c=relaxed/relaxed; d=mg.codeaurora.org; q=dns/txt;
 s=smtp; t=1605543970; h=Message-ID: References: In-Reply-To: Subject:
 Cc: To: From: Date: Content-Transfer-Encoding: Content-Type:
 MIME-Version: Sender; bh=uKUIgbcIuhe6YvGAalg12eIMU9eFBoTbuVmoryM3HdQ=;
 b=aacT05LQmz/lkVIyNMlexmVGvHudtYnGFL+0pIqAqrQyCALUAOJQLRizxkZEaCchbAqgcVTT
 3Wos9LcfcvS4aFu0qANGoNGTbTctvecb1TB/9970+zbSqqtZe0m8bYpxY1cGudQ0+cHgBm0o
 My783S6lYH5kmLNFEorg+oX7ApM=
X-Mailgun-Sending-Ip: 104.130.96.5
X-Mailgun-Sid: WyJlM2NhZSIsICJuZXRmaWx0ZXItZGV2ZWxAdmdlci5rZXJuZWwub3JnIiwgImJlOWU0YSJd
Received: from smtp.codeaurora.org
 (ec2-35-166-182-171.us-west-2.compute.amazonaws.com [35.166.182.171]) by
 smtp-out-n08.prod.us-west-2.postgun.com with SMTP id
 5fb2a82224ba9b3b025769ef (version=TLS1.2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256); Mon, 16 Nov 2020 16:26:10
 GMT
Sender: subashab=codeaurora.org@mg.codeaurora.org
Received: by smtp.codeaurora.org (Postfix, from userid 1001)
        id 1959BC43467; Mon, 16 Nov 2020 16:26:10 +0000 (UTC)
Received: from mail.codeaurora.org (localhost.localdomain [127.0.0.1])
        (using TLSv1 with cipher ECDHE-RSA-AES256-SHA (256/256 bits))
        (No client certificate requested)
        (Authenticated sender: subashab)
        by smtp.codeaurora.org (Postfix) with ESMTPSA id 21D91C433ED;
        Mon, 16 Nov 2020 16:26:09 +0000 (UTC)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 16 Nov 2020 09:26:09 -0700
From:   subashab@codeaurora.org
To:     Florian Westphal <fw@strlen.de>, pablo@netfilter.org
Cc:     Sean Tranchetti <stranche@codeaurora.org>,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH nf] x_tables: Properly close read section with
 read_seqcount_retry
In-Reply-To: <20201116141810.GB22792@breakpoint.cc>
References: <1605320516-17810-1-git-send-email-stranche@codeaurora.org>
 <20201114165330.GM23619@breakpoint.cc>
 <2ab4bcb63cbacba12ad927621fb56aab@codeaurora.org>
 <20201116141810.GB22792@breakpoint.cc>
Message-ID: <8256f40ba9b73181f121baafe12cac61@codeaurora.org>
X-Sender: subashab@codeaurora.org
User-Agent: Roundcube Webmail/1.3.9
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

>> We found that ip6t_do_table was reading stale values from the 
>> READ_ONCE
>> leading to use after free when dereferencing per CPU jumpstack values.
>> 
>> [https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/ipv6/netfilter/ip6_tables.c?h=v5.4.77#n282]
>> 	addend = xt_write_recseq_begin();
>> 	private = READ_ONCE(table->private); /* Address dependency. */
>> 
>> We were able to confirm that the xt_replace_table & __do_replace
>> had already executed by logging the seqcount values. The value of
>> seqcount at ip6t_do_table was 1 more than the value at 
>> xt_replace_table.
> 
> Can you elaborate? Was that before xt_write_recseq_begin() or after?

The log in ip6t_do_table was after xt_write_recseq_begin().

[https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/ipv6/netfilter/ip6_tables.c?h=v5.4.77#n282]
	addend = xt_write_recseq_begin();

The log in xt_replace_table was after raw_read_seqcount of 
per_cpu(xt_recseq)

[https://git.kernel.org/pub/scm/linux/kernel/git/stable/linux.git/tree/net/netfilter/x_tables.c?h=v5.4.77#n1400]
		seqcount_t *s = &per_cpu(xt_recseq, cpu);
		u32 seq = raw_read_seqcount(s);

In this specific run, we observed that the value in ip6t_do_table after
xt_write_recseq_begin() was 75316887. The value in xt_replace_table was 
after
raw_read_seqcount of per_cpu(xt_recseq) was 75316886. This confirms that 
the
private pointer assignment in xt_replace_table happened before the start 
of
ip6t_do_table.

> You mean
> "private = READ_ONCE(table->private); /* Address dependency. */" in
> ip6_do_table did pick up the 'old' private pointer, AFTER xt_replace
> had updated it?
> 

Yes, that is what we have observed from the logging.

>> diff --git a/net/netfilter/x_tables.c b/net/netfilter/x_tables.c
>> index 525f674..417ea1b 100644
>> --- a/net/netfilter/x_tables.c
>> +++ b/net/netfilter/x_tables.c
>> @@ -1431,11 +1431,11 @@ xt_replace_table(struct xt_table *table,
>>          * Ensure contents of newinfo are visible before assigning to
>>          * private.
>>          */
>> -       smp_wmb();
>> -       table->private = newinfo;
>> +       smp_mb();
>> +       WRITE_ONCE(table->private, newinfo);
> 
> The WRITE_ONCE looks correct.
> 
>>         /* make sure all cpus see new ->private value */
>> -       smp_wmb();
>> +       smp_mb();
> 
> Is that to order wrt. seqcount_sequence?

Correct, we want to ensure that the table->private is updated and is
in sync on all CPUs beyond that point.

> Do you have a way to reproduce such crashes?
> 
> I tried to no avail but I guess thats just because amd64 is more
> forgiving.
> 
> Thanks!

Unfortunately we are seeing it on ARM64 regression systems which runs a 
variety of
usecases so the exact steps are not known.
