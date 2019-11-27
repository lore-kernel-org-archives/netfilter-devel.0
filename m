Return-Path: <SRS0=TrSD=ZT=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-7.2 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,MENTIONS_GIT_HOSTING,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 82664C432C3
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 10:11:38 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 5598E2071E
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Nov 2019 10:11:38 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726603AbfK0KLh (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Nov 2019 05:11:37 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46719 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726292AbfK0KLg (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Nov 2019 05:11:36 -0500
Received: by mail-wr1-f67.google.com with SMTP id z7so22517937wrl.13
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Nov 2019 02:11:35 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:openpgp:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to
         :content-language:content-transfer-encoding;
        bh=Ltt13CGu5fNgKwSFhzzpYfnYJzpyScFnm2SCL6edOFA=;
        b=bjwCHJsFtvZu7tx85ubAmCfPrSU4T4qbw7JHlNgZTv2bbIrFqH8BVcXzpuyHoCsK7q
         2DOs9KuMb7v6wDBXMJDDzk0mAdz6exU1DSgQFHZ5Ise8nf4/NlqxKcGyHKO7kXUwrwxu
         nzm3QxNacsTQqci1Zt6ABDxQ5S616xq19B1LxE4HqkqL5QBBQO1TFiNXHk7pa5IhJB88
         /3JCfU+3TO8/hOgEmQhi0JMs1hHxnClmyyefOvSMlQkggkTWsOUGbBMKAHBV8aZ3uiL4
         nlturvKXgKp6KUK5rCz451fNbXUrpDGXVKFzm40VtQhcjfc8gur83Xg9TaZHPnyM9D/X
         mvKg==
X-Gm-Message-State: APjAAAWJzwPDwHITDa5opmJHskOoKFwgUASqGqsEXQJS6Ns1aStSuNJ9
        AEd7yJziXW6nUQ+QMbDAw91MUZLs
X-Google-Smtp-Source: APXvYqx9sq2iorUd2qxx4cci4YKJiVvsH54+odq5VlAyt0m+ZZtaA9d2UW+NBrmBxjR+lxeFWI/M/g==
X-Received: by 2002:adf:8bde:: with SMTP id w30mr2139874wra.124.1574849494419;
        Wed, 27 Nov 2019 02:11:34 -0800 (PST)
Received: from [192.168.1.9] (217.216.74.49.dyn.user.ono.com. [217.216.74.49])
        by smtp.gmail.com with ESMTPSA id x8sm18289130wrm.7.2019.11.27.02.11.33
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Nov 2019 02:11:33 -0800 (PST)
Subject: Re: Operation not supported when adding jump command
To:     "Serguei Bezverkhi (sbezverk)" <sbezverk@cisco.com>
Cc:     Phil Sutter <phil@nwl.cc>, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        Laura Garcia <nevola@gmail.com>
References: <5248B312-60A9-48A7-B4CF-E00D1BDF1CD2@cisco.com>
 <20191126122110.GD795@breakpoint.cc>
 <3DBD9E39-A0DF-4A69-93CC-4344617BDB2F@cisco.com>
 <20191126153850.pblaoj4xklfz5jgv@salvia>
 <427E92A6-2FFA-47CF-BF3B-C08961C978C9@cisco.com>
 <20191126155125.GD8016@orbyte.nwl.cc>
 <0A92D5EA-B158-4C7A-B85C-1692AE7C828B@cisco.com>
 <20191126192752.GE8016@orbyte.nwl.cc>
 <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Openpgp: preference=signencrypt
Autocrypt: addr=arturo@netfilter.org; keydata=
 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
 EXgmBmyUKrJkh/zvupp9t9Y2ioPbcMObRIEXio4=
Message-ID: <3a457e5b-be8f-e99d-fb0d-4826a15a4a55@netfilter.org>
Date:   Wed, 27 Nov 2019 11:11:32 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.9.0
MIME-Version: 1.0
In-Reply-To: <AC4B6BFD-30FA-4A62-AD3C-3EB37029EC1B@cisco.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 11/26/19 10:20 PM, Serguei Bezverkhi (sbezverk) wrote:
>     On Tue, Nov 26, 2019 at 06:47:09PM +0000, Serguei Bezverkhi (sbezverk) wrote:
>     > Ok, I guess I will work around by using input and output chain types, even though it will raise some brows in k8s networking community.
>     > 

@Sergei, thanks for reaching out about this topic.

I'm using k8s a lot lately and would be interested in knowing more about what
you are trying to do with kubernetes and nftables.

In any case, if the somebody in kubernetes is planning to introduce nft for
kube-proxy or other component, I would suggest the generated ruleset is
validated here to really benefit from nftables. Is this what you are doing, right?

Recently I had the chance to attend a talk by @Laura (in CC) about the iptables
ruleset generated by docker and kube-proxy. Such rulesets are the opposite of
something meant to scale and perform well. Then people compare such rulesets
with other networking setups... and unfair compare.

Worth mentioning at this point this PoC too:

https://github.com/zevenet/kube-nftlb

Trying to mimic 1:1 what iptables was doing is a mistake from my point of view.
I believe you are aware of this already :-)

>     
>     Keeping both target address and port in a single map for *NAT statements
>     is not possible AFAIK.

@Phil, I think it is possible! examples in the wiki:

https://wiki.nftables.org/wiki-nftables/index.php/Multiple_NATs_using_nftables_maps

It would be something like:

% nft add rule nat prerouting dnat \
      tcp dport map { 1000 : 1.1.1.1, 2000 : 2.2.2.2, 3000 : 3.3.3.3} \
      : tcp dport map { 1000 : 1234, 2000 : 2345, 3000 : 3456 }


>     
>     If I'm not mistaken, you might be able to hook up a vmap together with
>     the numgen expression above like so:
>     
>     | numgen random mod 0x2 vmap { \
>     |	0x0: jump KUBE-SEP-FS3FUULGZPVD4VYB, \
>     |	0x1: jump KUBE-SEP-MMFZROQSLQ3DKOQA }
>     
>     Pure speculation, though. :)
>     

This works indeed. Just added the example to the wiki:

https://wiki.nftables.org/wiki-nftables/index.php/Load_balancing#Round_Robin


