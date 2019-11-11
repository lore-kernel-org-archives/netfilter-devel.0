Return-Path: <SRS0=qfGK=ZD=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.2 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6DAA9C43331
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 22:09:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 40D7F2196E
	for <netfilter-devel@archiver.kernel.org>; Mon, 11 Nov 2019 22:09:40 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=gmail.com header.i=@gmail.com header.b="S2K/uSbR"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726991AbfKKWJj (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 11 Nov 2019 17:09:39 -0500
Received: from mail-pf1-f175.google.com ([209.85.210.175]:45427 "EHLO
        mail-pf1-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726845AbfKKWJj (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 11 Nov 2019 17:09:39 -0500
Received: by mail-pf1-f175.google.com with SMTP id z4so11635644pfn.12
        for <netfilter-devel@vger.kernel.org>; Mon, 11 Nov 2019 14:09:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=rbhPb3AExeG4sabwXI0ApAFLaLSrPqiez1CSpc8pa1c=;
        b=S2K/uSbR8Gkpa5QeCdespvlFGQoQeraurBdlNuHfWClazVQ7SC34BUU/WSqpTb+rxo
         bc/XevxBV/JgSUEUL2a48KHmlm2HBB3HDz+IlXGuZxZ2sKU0QRNpkc0O+Epw5qK6fSu4
         +DgPx+JmEIrRMIHYC4VQe7gNDGRpFrMkw/dU9oYWcNWnu+U8bgK0WhNxUpCjF03WkGEQ
         dNkua6aKHCz/0RCtW2g1JU4HW1ebXCyH+s90YXTwfpfWZ97ooN6tMeZsXm5x5OaQVXz5
         SLLD58znWEgITXNejNWQXnDJK2OgAy/riRQNaFotTsykMxFtn1cw+RDLBrqd1B4OMI6N
         qRCw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=rbhPb3AExeG4sabwXI0ApAFLaLSrPqiez1CSpc8pa1c=;
        b=pJlJFpscueogh6/7j1V5nwYWHEXBy1cx6VkUza5P24kdp0KcGRsawjuc/2OgIVUR5/
         jOpbdqfRJ92W74ACMCe7Rqqm2BZbvvU3lsUaF+iEd7iLhd5im/Z/Ktk03Z3+lns6wCxW
         9IounHfUaSpVX8pw57l3E4hr5VpnvwH5JCmkwNrj3UBdK/3tpG1WOX+gDa/8uNltv8Ks
         R2YzbOP47jNEiBMzB8IybwXYpwdpRCpw7pXleG74OXLNmK5hGjS9zrQYAU/vcUuu35wJ
         L5koVpztqZ9k4R0UHtj+a20TnssbdXw/toeNlCzfVuKq7+1ZyTwdRnlOViV2jle6mVG7
         dlIQ==
X-Gm-Message-State: APjAAAXJgDE9Aee5Mm9/ZTkgaKm3GdPS2AWCXBe4XAQqtm5inmVfGtpW
        WBaJiW+8GpN16a7FncJHncKy7bG/
X-Google-Smtp-Source: APXvYqzs+I4RdRDKIiABxDmkrMEcQCRTw1dPwN/QbiikM8r/Hu6ONAWuBk8IJij698HMA/Lkk4wFGQ==
X-Received: by 2002:a63:1c05:: with SMTP id c5mr9753684pgc.398.1573510176598;
        Mon, 11 Nov 2019 14:09:36 -0800 (PST)
Received: from ?IPv6:2620:15c:2c1:200:55c7:81e6:c7d8:94b? ([2620:15c:2c1:200:55c7:81e6:c7d8:94b])
        by smtp.gmail.com with ESMTPSA id s3sm374785pjn.21.2019.11.11.14.09.35
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 11 Nov 2019 14:09:35 -0800 (PST)
Subject: Re: UAF in ip6_do_table on 4.19 kernel
To:     stranche@codeaurora.org, fw@strlen.de,
        netfilter-devel@vger.kernel.org
Cc:     Subashab <subashab@codeaurora.org>
References: <e7501cbd85e96b111f5c404200a3a330@codeaurora.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <44a69247-87bd-905d-bd1c-e9dcb5027641@gmail.com>
Date:   Mon, 11 Nov 2019 14:09:26 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <e7501cbd85e96b111f5c404200a3a330@codeaurora.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org



On 11/11/19 12:49 PM, stranche@codeaurora.org wrote:
> Hi all,
> 
> We recently had a crash reported to us on the 4.19 kernel where ip6_do_table() appeared to be referencing a jumpstack that had already been freed.
> Based on the dump, it appears that the scenario was a concurrent use of iptables-restore and active data transfer. The kernel has Florian's commit
> to wait in xt_replace_table instead of get_counters(), 80055dab5de0 ("netfilter: x_tables: make xt_replace_table wait until old rules are not used
> anymore"), so it appears that xt_replace_table is somehow returning prematurely, allowing __do_replace() to free the table while it is still in use.
> 
> After reviewing the code, we had a question about the following section:
>     /* ... so wait for even xt_recseq on all cpus */
>     for_each_possible_cpu(cpu) {
>         seqcount_t *s = &per_cpu(xt_recseq, cpu);
>         u32 seq = raw_read_seqcount(s);
> 
>         if (seq & 1) {
>             do {
>                 cond_resched();
>                 cpu_relax();
>             } while (seq == raw_read_seqcount(s));
>         }
>     }

The intent of this code is to check that each cpu went through a phase where the seq was even at least once.

> 
> Based on the other uses of seqcount locks, there should be a paired read_seqcount_retry() to mark the end of the read section like below:
>     for_each_possible_cpu(cpu) {
>         seqcount_t *s = &per_cpu(xt_recseq, cpu);
>         u32 seq;
> 
>         do {
>             seq = raw_read_seqcount(s);
>             if (seq & 1) {
>                 cond_resched();
>                 cpu_relax();
>             }
>         } while (read_seqcount_retry(s, seq);

This would loop possibly more times, since you exit if the count is _currently_ even.
 
If we are unlucky this could loop for a very long time.

>     }
> 
> These two snippets are very similar, as the original seems like it attempted to open-code this retry() helper, but there is a slight difference in
> the smp_rmb() placement relative to the "retry" read of the sequence value.
> Original:
>     READ_ONCE(s->sequence);
>     smp_rmb();
>     ... //check and resched
>     READ_ONCE(s->sequence);
>     smp_rmb();
>     ... //compare the two sequence values
> 
> Modified using read_seqcount_retry():
>     READ_ONCE(s->sequence);
>     smp_rmb();
>     ... //check and and resched
>     smp_rmb();
>     READ_ONCE(s->sequence);
>     ... //compare the two sequence values
> 
> Is it possible that this difference in ordering could lead to an incorrect read of the sequence in certain neurotic scenarios? Alternatively, is there
> some other place that this jumpstack could be freed while still in use?
> 

4.19 has many bugs really. Please upgrade to v4.19.83


