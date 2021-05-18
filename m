Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.9 required=3.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,MAILING_LIST_MULTI,NICE_REPLY_A,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B783EC433ED
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 16:48:43 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 89BB0611BD
	for <netfilter-devel@archiver.kernel.org>; Tue, 18 May 2021 16:48:43 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346670AbhERQuA (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 18 May 2021 12:50:00 -0400
Received: from mail.kernel.org ([198.145.29.99]:48948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230355AbhERQuA (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 18 May 2021 12:50:00 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1697C610CC;
        Tue, 18 May 2021 16:48:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621356522;
        bh=zXR3Hanni8X3VHzSL8IMkbQsAnmnqwMzRcTT2iBKdD0=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=DC7xs6sj89Y7+S84BjW/WqZPapZzTK9NJJ6tyZNHZWohy4/YUJH8BbKYxzBAI91MW
         frfQu+POt1grW++XLaR4FUWfPqGjr+BFVGBJxMvBL4hVencSgxns/yqIAdxIDa+Z85
         arf3VVVwJCu5NgGicAirswkq6L/YQG7JZExbLFoAMuFWY8LJi88TFt0z3o4eYazM5p
         7RfTQWer3A7aEq4COdTukRDY4qQaPmrpLwAgud7k8KyiKPWzPbf8wikqzwMqnaA/mn
         SzjE1p90Nb0/XVnttRbAv3MTowq4v0VFB9L+7AZUXxUmKu4Q9yyvsrADJ56wQhl0xT
         tEGEX8Um0CIow==
Subject: Re: [PATCH nf-next] nft_set_pipapo_avx2: Skip LDMXCSR, we don't need
 a valid MXCSR state
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Stefano Brivio <sbrivio@redhat.com>
Cc:     netfilter-devel@vger.kernel.org
References: <1c53a6ec42c6ee933231eeeca27285f405cb0bf4.1620613229.git.sbrivio@redhat.com>
 <20210518160159.GA24307@salvia>
From:   Andy Lutomirski <luto@kernel.org>
Message-ID: <61461a47-acc3-877e-e5ec-5d4de1c7db45@kernel.org>
Date:   Tue, 18 May 2021 09:48:41 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210518160159.GA24307@salvia>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 5/18/21 9:01 AM, Pablo Neira Ayuso wrote:
> On Mon, May 10, 2021 at 07:58:52AM +0200, Stefano Brivio wrote:
>> We don't need a valid MXCSR state for the lookup routines, none of
>> the instructions we use rely on or affect any bit in the MXCSR
>> register.
>>
>> Instead of calling kernel_fpu_begin(), we can pass 0 as mask to
>> kernel_fpu_begin_mask() and spare one LDMXCSR instruction.
>>
>> Commit 49200d17d27d ("x86/fpu/64: Don't FNINIT in kernel_fpu_begin()")
>> already speeds up lookups considerably, and by dropping the MCXSR
>> initialisation we can now get a much smaller, but measurable, increase
>> in matching rates.
>>
>> The table below reports matching rates and a wild approximation of
>> clock cycles needed for a match in a "port,net" test with 10 entries
>> from selftests/netfilter/nft_concat_range.sh, limited to the first
>> field, i.e. the port (with nft_set_rbtree initialisation skipped), run
>> on a single AMD Epyc 7351 thread (2.9GHz, 512 KiB L1D$, 8 MiB 

Please consider reverting this patch.  You have papered over the actual
problem, which is that the kernel does not get the AVX pipeline stalls
right.  LDMXCSR merely exacerbates the problem, but your patch won't
really fix it.

A real fix is on my radar.  If you end up applying this patch, I'll
probably revert it later.
