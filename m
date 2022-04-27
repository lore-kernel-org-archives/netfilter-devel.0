Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 6CFFBC433EF
	for <netfilter-devel@archiver.kernel.org>; Wed, 27 Apr 2022 15:00:59 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238879AbiD0PEH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 27 Apr 2022 11:04:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238868AbiD0PEG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 27 Apr 2022 11:04:06 -0400
Received: from mail-lj1-x235.google.com (mail-lj1-x235.google.com [IPv6:2a00:1450:4864:20::235])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39FB52715D0
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 08:00:54 -0700 (PDT)
Received: by mail-lj1-x235.google.com with SMTP id s27so3031509ljd.2
        for <netfilter-devel@vger.kernel.org>; Wed, 27 Apr 2022 08:00:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=cqPvQO3nvr14PSgq5iF8J05P5Y31SBLrmAZyNjHN7bU=;
        b=hKII8xRMNL2s+OdFPZSZEdOEpS/i+Lsv3hB6WzCR+/wRB4RCZUga2nV13CNFVHtUnm
         iMQy4oS1rrGlzuU07cXJrQKnlVxblloyd1KNhj28YxN3Y7o2PFivsixdE9M0u29gaBf2
         YxPdlMmV62Ka2dWjYDEupAB+FGfVMJLBbBV8ep8/ReVoMwd7Mwpj2gLhIqiKN+L53oj+
         eQa0zLRSBvnNH3C1aH83fqEg7/XSygohdoiDBhi7G4FANUXqWTiw3O8l1BGd4hJZpxRQ
         0REq70uQGELlUaFGT2VHVIF0tsR6Y28LQwE56i6DkVXpwyfJJgHIIQlicLEdVh4CJ14K
         +jMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=cqPvQO3nvr14PSgq5iF8J05P5Y31SBLrmAZyNjHN7bU=;
        b=DqT5TYTmSCnwqN4kQDfg5lr5T3FQiq+AxTvBhc45ulC3gbS2hL28aj/93OHjKaWdco
         CjaEpGtmNJxzc70JhPM+199uFToBBgOUR8eKDWc6Oovz/10juK4AiSktyF/IHK6K3qKN
         w5zKTrx4a1BWxOeSCWYB950LkqOtSSl9WD5ecZsMRYdcNruT+CEY3/kFUW1/LZlis4oF
         DSIliAGJ6hZhHS09xo9aZ64N+FV/KTrlaOKqy+30lGfNbCmObZvZ8q7zc2gV6V4BWCmj
         N6DOw2oes5emWX+5/zMeByNJ9g3QXFA8F9hnyhutptovErk9FuAcfVRBhXRWmyMhnvlk
         cgAw==
X-Gm-Message-State: AOAM532FRH6NmygNCWWjOqGjMlKh4c5r/l66ptC69ZFU+6hUjUMFDz6h
        NXYW6ROAu7kmMzzuuDAXNWo=
X-Google-Smtp-Source: ABdhPJy0cUJu0gDMKX4hXASpi6nTqZyDCDJApUAMSHAoztEG6ZutlurVv+QbVZvl0wIpkbxTQXGsJg==
X-Received: by 2002:a2e:9e4b:0:b0:24e:e97d:6ba9 with SMTP id g11-20020a2e9e4b000000b0024ee97d6ba9mr18596217ljk.92.1651071652222;
        Wed, 27 Apr 2022 08:00:52 -0700 (PDT)
Received: from [192.168.1.38] (91-159-150-194.elisa-laajakaista.fi. [91.159.150.194])
        by smtp.gmail.com with ESMTPSA id s22-20020a195e16000000b00471fe476a26sm1448308lfb.41.2022.04.27.08.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 27 Apr 2022 08:00:51 -0700 (PDT)
Message-ID: <b0389581-cf28-13fe-6444-0840958b757a@gmail.com>
Date:   Wed, 27 Apr 2022 18:00:49 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.0
Subject: Re: [PATCH] netfilter: nft_socket: socket expressions for GID & UID
Content-Language: en-US
To:     Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Cc:     netfilter-devel@vger.kernel.org
References: <20220420185447.10199-1-toiwoton@gmail.com>
 <5a292abd-7f2e-728f-5594-86d85fbd1c00@gmail.com>
 <20220425223421.GA14400@breakpoint.cc>
 <ab7923f2-d1e7-ce61-5df8-c05778ef3ebd@gmail.com>
 <20220427054820.GB9849@breakpoint.cc> <YmjqN7KtWFMGbiJ9@salvia>
From:   Topi Miettinen <toiwoton@gmail.com>
In-Reply-To: <YmjqN7KtWFMGbiJ9@salvia>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 27.4.2022 10.01, Pablo Neira Ayuso wrote:
> On Wed, Apr 27, 2022 at 07:48:20AM +0200, Florian Westphal wrote:
>> Topi Miettinen <toiwoton@gmail.com> wrote:
>>> On 26.4.2022 1.34, Florian Westphal wrote:
>>>> Topi Miettinen <toiwoton@gmail.com> wrote:
>>>>> On 20.4.2022 21.54, Topi Miettinen wrote:
>>>>>> Add socket expressions for checking GID or UID of the originating
>>>>>> socket. These work also on input side, unlike meta skuid/skgid.
>>>>>
>>>>> Unfortunately, there's a reproducible kernel BUG when closing a local
>>>>> connection:
>>>>>
>>>>> Apr 25 21:18:13 kernel:
>>>>> ==================================================================
>>>>> Apr 25 21:18:13 kernel: BUG: KASAN: null-ptr-deref in
>>>>> nf_sk_lookup_slow_v6+0x45b/0x590 [nf_socket_ipv6]
>>>>
>>>> You can pass this to scripts/faddr2line to get the location of the null deref.
>>>
>>> Didn't work,
>>
>> ?
>>
>> You pass the object file and the nf_sk_lookup_slow_v6+0x45b/0x590 info.
>> I can't do it for you because I lack the object file and the exact
>> source code.
>>

$ faddr2line nf_socket_ipv6.ko nf_sk_lookup_slow_v6+0x45b/0x590
bad symbol size: base: 0x0000000000000000 end: 0x0000000000000000
$ faddr2line nf_socket_ipv6.o nf_sk_lookup_slow_v6+0x45b/0x590
bad symbol size: base: 0x0000000000000000 end: 0x0000000000000000
$ faddr2line nf_socket_ipv6.mod nf_sk_lookup_slow_v6+0x45b/0x590
readelf: Error: nf_socket_ipv6.mod: Failed to read file header
size: nf_socket_ipv6.mod: file format not recognized
nm: nf_socket_ipv6.mod: file format not recognized
size: nf_socket_ipv6.mod: file format not recognized
nm: nf_socket_ipv6.mod: file format not recognized
no match for nf_sk_lookup_slow_v6+0x45b/0x590
$ faddr2line nf_socket_ipv6.mod.o nf_sk_lookup_slow_v6+0x45b/0x590
no match for nf_sk_lookup_slow_v6+0x45b/0x590
$ faddr2line vmlinux nf_sk_lookup_slow_v6+0x45b/0x590
no match for nf_sk_lookup_slow_v6+0x45b/0x590

>>> net/ipv6/netfilter/nf_socket_ipv6.c:
>>>
>>> static struct sock *
>>> nf_socket_get_sock_v6(struct net *net, struct sk_buff *skb, int doff,
>>>                        const u8 protocol,
>>>                        const struct in6_addr *saddr, const struct in6_addr
>>> *daddr,
>>>                        const __be16 sport, const __be16 dport,
>>>                        const struct net_device *in)
>>> {
>>>          switch (protocol) {
>>>          case IPPROTO_TCP:
>>>                  return inet6_lookup(net, &tcp_hashinfo, skb, doff,
>>>                                      saddr, sport, daddr, dport,
>>>                                      in->ifindex);
>>
>> What does that rule look like?  Seems like no input interface is
>> available, seems like a bug in existing code?
> 
> nft_socket_eval() assumes it always run from input path.
> 
> @Topi: How does you test ruleset look like?

Here's a reproducer:
#!/usr/sbin/nft -f

table inet mangle {
         chain output {
                 type route hook output priority mangle; policy accept;

                 socket uid != 0 reject with icmpx type admin-prohibited
         }
}

Start nc -6l 1 as root

Try 'telnet ::1 1' as root, press enter and close the connection. After 
1-3 tries, system hangs and Caps Lock starts blinking.

-Topi
