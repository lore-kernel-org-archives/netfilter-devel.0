Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B7E1EEE01FD
	for <netfilter-devel@archiver.kernel.org>; Wed, 13 Sep 2023 17:51:40 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231630AbjIMRvn (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 13 Sep 2023 13:51:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41530 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230311AbjIMRvm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 13 Sep 2023 13:51:42 -0400
X-Greylist: delayed 565 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Wed, 13 Sep 2023 10:51:36 PDT
Received: from mail-1.server.selfnet.de (mail-1.server.selfnet.de [IPv6:2001:7c7:2100:400::37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A524619AF
        for <netfilter-devel@vger.kernel.org>; Wed, 13 Sep 2023 10:51:36 -0700 (PDT)
Received: from [127.0.0.1] (localhost [127.0.0.1]) by localhost (Mailerdaemon) with ESMTPSA id 885AD41588;
        Wed, 13 Sep 2023 19:42:02 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=selfnet.de; s=selfnet;
        t=1694626923;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
        to:to:cc:cc:mime-version:mime-version:content-type:content-type:autocrypt:autocrypt;
        bh=+6yLW7g/amAvYHS/3Qd0RHSLgzGzriXEN/oMuiMG0vs=;
        b=bVS5Xan4iR+apyhXgV3of//tgznEPgB+99uoDUEiWeNMPzh+/qy37TvEeceCmipgrmjA1v
        jPI3Bg5cpcL9wedC7xb+WLNJBphlM1WNuPB2SH7SiTazPJL6NR3VJgv4dF33+vqxbbuTfG
        0uT5wv0oF1gDITMx/jDLO9rOXou6GiwoGEva0QfmTzAtEYHtTlnalsEOFB2fGFGiYXlmQ3
        jV2KinxrlkOA+qNEC8QaTkxX4/OCTSCHVgB8jb4GQZRmuwfODnFFfqrR3O4FzIwtdNozkb
        nQFc2UTzvyWMiaUs4tj33IkeIifq+hy055PetS3uA0ymr2eWN1uz47Qfw+lv3w==
Authentication-Results: mail-1.server.selfnet.de;
        auth=pass smtp.auth=jannh smtp.mailfrom=jannh@selfnet.de
Content-Type: multipart/mixed; boundary="------------C8Q5SBHIxWFuovLTSA71UhC1"
Message-ID: <f65ce9da-e780-433d-be98-44080754109e@selfnet.de>
Date:   Wed, 13 Sep 2023 19:42:01 +0200
MIME-Version: 1.0
User-Agent: Mozilla Thunderbird
From:   Jann Haber <jannh@selfnet.de>
To:     netfilter-devel@vger.kernel.org
Cc:     Jonas Burgdorf <jonas@selfnet.de>, technik@selfnet.de
Content-Language: en-US
Subject: Issue with counter and interval map
Autocrypt: addr=jannh@selfnet.de; keydata=
 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
 WHNJ3cmDuyd7EfOt
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

This is a multi-part message in MIME format.
--------------C8Q5SBHIxWFuovLTSA71UhC1
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit

Dear nftables-developers,

at Selfnet, we have been operating our CGN based on nftables for roughly 4 years now (at that time we switched from iptables). Recently, we have upgraded our first server from Debian bullseye (Kernel 5.10, nftables 0.9.8) to bookworm (Kernel 6.1, nftables 1.0.6). On bookworm, our ruleset that works well on bullseye fails to load.

We have boiled it down to the minimal example attached, which fails to load correctly on bookworm and also on a current Arch-Linux.

xxxxx@xxxxx:~$ sudo nft -f example.conf
example.conf:5:35-48: Error: Could not process rule: No such file or directory
add element inet filter testmap { 192.168.0.0/24 : "TEST" }
                                   ^^^^^^^^^^^^^^
What we have tested:
- Removing the last line from the file and running it later manually via the command line, there is no error
- Splitting the file in two (having the final line in a separate file), the two files can be applied with two nft -f calls with no error
- When swapping the lines 3 and 4 (i.e. first add counter, then add map), there is no error applying the file
- Removing "flags: interval" from the map and testing with a single IP, there is no error applying the file

In summary, I believe our rule syntax is ok - but something is going wrong when the rules are applied in the given order atomically with "nft -f". We appreciate any insight, please also let us know if we did something wrong or if we can assist with debugging further.

Thank you and best Regards,
Jann
--------------C8Q5SBHIxWFuovLTSA71UhC1
Content-Type: text/plain; charset=UTF-8; name="example.conf"
Content-Disposition: attachment; filename="example.conf"
Content-Transfer-Encoding: base64

Zmx1c2ggcnVsZXNldAphZGQgdGFibGUgaW5ldCBmaWx0ZXIKYWRkIG1hcCBpbmV0IGZpbHRl
ciB0ZXN0bWFwIHsgdHlwZSBpcHY0X2FkZHIgOiBjb3VudGVyOyBmbGFncyBpbnRlcnZhbDt9
CmFkZCBjb3VudGVyIGluZXQgZmlsdGVyIFRFU1QKYWRkIGVsZW1lbnQgaW5ldCBmaWx0ZXIg
dGVzdG1hcCB7IDE5Mi4xNjguMC4wLzI0IDogIlRFU1QiIH0K

--------------C8Q5SBHIxWFuovLTSA71UhC1--
