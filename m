Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 8D04BEED61E
	for <netfilter-devel@archiver.kernel.org>; Fri, 15 Sep 2023 17:52:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235532AbjIORwM (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 15 Sep 2023 13:52:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35196 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236385AbjIORv5 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 15 Sep 2023 13:51:57 -0400
Received: from mail-1.server.selfnet.de (mail-1.server.selfnet.de [IPv6:2001:7c7:2100:400::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 632651BF2
        for <netfilter-devel@vger.kernel.org>; Fri, 15 Sep 2023 10:51:47 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 2DA4A411A7;
        Fri, 15 Sep 2023 19:51:39 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=selfnet.de; s=selfnet;
        t=1694800299;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references:autocrypt:autocrypt;
        bh=MWU/c4DyFuHqeLmIr6StTxbxDIS6tTDHv5ye03apS+w=;
        b=J1eij7UNJdR76DoLFTo6ucj6eB3lqF5yupY8inBT+vcYvYpLapwlbJaFUJsNd4/+4EZ4Kp
        a5SGfZAroFb6LxDk6PgvTVXHgBEYmPRW+Ne39JZwQ5zqwL/Uf0dxdWNajmOL7cwnuT73rW
        UszULt3qNLkvsZ9izecSj2hidqNDu4uUIveMNYcF0WEWib142v5JGd0h4pT589bBr/ixv3
        gxEEgQIzaNwKWUDs+iI0DOe5PNTdgTWGD+559OnWwdeeCGA/EMwZbSm1P7rG6i+MiYkCyN
        UQUKZ85rE2PNwmejUeieb6mt3GtXAEkmVKuxtc2ng4mMtHG3iWeMJOPWFSYAoA==
Authentication-Results: mail-1.server.selfnet.de;
        auth=pass smtp.auth=jannh smtp.mailfrom=jannh@selfnet.de
Content-Type: multipart/mixed; boundary="------------IrgR7RUjdwbfG0bt0L6GXytD"
Message-ID: <5359e787-d056-480a-8154-9cf459dd5bea@selfnet.de>
Date:   Fri, 15 Sep 2023 19:51:37 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
Subject: Re: Issue with counter and interval map
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, Jonas Burgdorf <jonas@selfnet.de>
References: <f65ce9da-e780-433d-be98-44080754109e@selfnet.de>
 <ZQI89KmxZpTEKYN9@calendula>
Content-Language: en-US
From:   Jann Haber <jannh@selfnet.de>
Autocrypt: addr=jannh@selfnet.de; keydata=
 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
 WHNJ3cmDuyd7EfOt
In-Reply-To: <ZQI89KmxZpTEKYN9@calendula>
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------IrgR7RUjdwbfG0bt0L6GXytD
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Hi Pablo,

thank you first of all for your prompt response, very appreciated!

We have a second issue also related to interval maps and counters, however this seems to be more along the lines of a userspace performance problem. At Selfnet, we will soon hit 7000 members, with our traffic running across two redundant CGN machines powered by nftables. Naturally, our maps and sets can become quite large and may have some tens of thousands of entries.

I have attached a small python script that creates an "example.conf" file containing a simple set of very repetitive rules including counters and 4 interval maps each of the size ~16000 entries referencing these counters. On our bookworm and ArchLinux hosts, the resulting rules take very long to load with "nft -f" (at least multiple minutes). All other maps in our ruleset, some of which have similar size, are loaded instantly, so the size itself seems not to be an issue for nft in general.
If needed I can also provide the example.conf file itself, but due to the size of a few MB, I rather avoid to spam the mailing list.

Further info:
- With a regular map instead of an interval map (just remove the "flags interval" in the example), the rules are loaded in fractions of a second
- Using add map { [...] elements = [...] } instead of add map { [...] }; add element [...]; add element [...] and so on, the ruleset is also loaded quickly (this is our workaround that we use for now)
- We have had no issues with this kind of ruleset on Debian Bullseye (Kernel 5.10, nftables 0.9.8), it seems to have been introduced later

Thanks again and looking forward to your feedback!

Kind Regards,
Jann
--------------IrgR7RUjdwbfG0bt0L6GXytD
Content-Type: text/x-python; charset=UTF-8; name="nftables-slow.py"
Content-Disposition: attachment; filename="nftables-slow.py"
Content-Transfer-Encoding: base64

Cgp3aXRoIG9wZW4oImV4YW1wbGUuY29uZiIsICJ3IikgYXMgZjoKICAgIHByaW50KCJJbml0
aWFsIGxpbmVzIikKICAgIGYud3JpdGUoImZsdXNoIHJ1bGVzZXRcbiIpCiAgICBmLndyaXRl
KCJhZGQgdGFibGUgaW5ldCBmaWx0ZXJcbiIpCgogICAgcHJpbnQoIkNvdW50ZXJzIikKICAg
IGZvciBpIGluIHJhbmdlKDMyKjI1Nik6CiAgICAgICAgZi53cml0ZShmImFkZCBjb3VudGVy
IGluZXQgZmlsdGVyIGNvdW50e2l9XG4iKQoKICAgIHByaW50KCJNYXAiKQogICAgZi53cml0
ZSgiXG5hZGQgbWFwIGluZXQgZmlsdGVyIHRlc3RtYXAwIHsgdHlwZSBpcHY0X2FkZHIgOiBj
b3VudGVyOyBmbGFncyBpbnRlcnZhbDt9XG5cbiIpCiAgICBmLndyaXRlKCJcbmFkZCBtYXAg
aW5ldCBmaWx0ZXIgdGVzdG1hcDEgeyB0eXBlIGlwdjRfYWRkciA6IGNvdW50ZXI7IGZsYWdz
IGludGVydmFsO31cblxuIikKICAgIGYud3JpdGUoIlxuYWRkIG1hcCBpbmV0IGZpbHRlciB0
ZXN0bWFwMiB7IHR5cGUgaXB2NF9hZGRyIDogY291bnRlcjsgZmxhZ3MgaW50ZXJ2YWw7fVxu
XG4iKQogICAgZi53cml0ZSgiXG5hZGQgbWFwIGluZXQgZmlsdGVyIHRlc3RtYXAzIHsgdHlw
ZSBpcHY0X2FkZHIgOiBjb3VudGVyOyBmbGFncyBpbnRlcnZhbDt9XG5cbiIpCiAgICAjZi53
cml0ZSgiXG5hZGQgbWFwIGluZXQgZmlsdGVyIHRlc3RtYXAwIHsgdHlwZSBpcHY0X2FkZHIg
OiBjb3VudGVyO31cblxuIikKICAgICNmLndyaXRlKCJcbmFkZCBtYXAgaW5ldCBmaWx0ZXIg
dGVzdG1hcDEgeyB0eXBlIGlwdjRfYWRkciA6IGNvdW50ZXI7fVxuXG4iKQogICAgI2Yud3Jp
dGUoIlxuYWRkIG1hcCBpbmV0IGZpbHRlciB0ZXN0bWFwMiB7IHR5cGUgaXB2NF9hZGRyIDog
Y291bnRlcjt9XG5cbiIpCiAgICAjZi53cml0ZSgiXG5hZGQgbWFwIGluZXQgZmlsdGVyIHRl
c3RtYXAzIHsgdHlwZSBpcHY0X2FkZHIgOiBjb3VudGVyO31cblxuIikKCiAgICBmb3IgaSBp
biByYW5nZSgyNTYpOgogICAgICAgIGZvciBqIGluIHJhbmdlKDI1Nik6CiAgICAgICAgICAg
IGNvdW50ID0gKGkqMjU2K2opICUgKDMyKjI1NikKICAgICAgICAgICAgbWFwX251bWJlciA9
IGNvdW50ICUgNAogICAgICAgICAgICBmLndyaXRlKGYiYWRkIGVsZW1lbnQgaW5ldCBmaWx0
ZXIgdGVzdG1hcHttYXBfbnVtYmVyfSB7eyAxMC4wLntpfS57an0gOiBcImNvdW50e2NvdW50
fVwiIH19XG4iKQo=

--------------IrgR7RUjdwbfG0bt0L6GXytD--
