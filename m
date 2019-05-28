Return-Path: <SRS0=QEZg=T4=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-1.0 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=unavailable autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B67AEC072B1
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 21:50:07 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 8AA6D217D4
	for <netfilter-devel@archiver.kernel.org>; Tue, 28 May 2019 21:50:07 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20150623.gappssmtp.com header.i=@mojatatu-com.20150623.gappssmtp.com header.b="M88efnyg"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727563AbfE1VuE (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 28 May 2019 17:50:04 -0400
Received: from mail-qk1-f169.google.com ([209.85.222.169]:33204 "EHLO
        mail-qk1-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfE1VuD (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 28 May 2019 17:50:03 -0400
Received: by mail-qk1-f169.google.com with SMTP id p18so168004qkk.0
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2019 14:50:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=z/7pXtnMoeggltCSRBU8g1Ph8yIX8YybN3BYB2Nub7M=;
        b=M88efnygAdBVsYYFERpz+hJnD0s88uqDVdZT9yN3lhrUh3AonvywZq0nWRAPIuuFTe
         qGzK6FeNsQii8STBodXVAqddlygBU2ed+EuCQsZZ4KYrHdsw60u9ffajOGt4mIl5NVEI
         HlY9hWWT/YRJet4aciG7s6FN+44st/4UHq95umr9jx9pLfWhSm/RenJNaaxoqpLfH5Ba
         o/s8xYGQZDBf51l7v78rgPS2+7qWdj08Yz7yapHEoCPsknAz2FLxQNEG+O7LWiYwI99h
         blQ0Wyy6F8ecKqr14Z7roi0cC8On3INyXf7tYQO+1+c+H3YEMqiFcomlodFu0g6/rJxn
         KrNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=z/7pXtnMoeggltCSRBU8g1Ph8yIX8YybN3BYB2Nub7M=;
        b=imf3utaG9DEe6LyD6PnyQfyeX8RLR9gMJ29xr4A0z+lsEMO+Voqo3oItdICPsU/zh6
         U4q9UtuE07kRXH4LFJWYRUK0A9o20XNwxfZQD5IqS5dv6agPPo/Okx21gSBQNaaaECAS
         A8N9edCfi8SkTqLYUKG40TeIyH0md2x+/aEkTat4UrJceo8uGB9y3qM/b/mXFqajVQ1T
         FumYRDhVzlVLYtdPx6ZEj+lpm7mq6Zc9E3zbth4Br9TXDKZqeE9FsUvfN7qSDGHSXg82
         4hq52aCs4vCBk39Om+hUxI0p4bzp+L1bnukDutR0/U2xHU1pPyh3pQop3qoE23+HqYqt
         cY9A==
X-Gm-Message-State: APjAAAVcyODTeiMLPl5rvtpAFondrHMJHdWbagtd5Z45ORSPZxcbNNt4
        TFFxHq+9Dz123qXrLT/GfRnnjA==
X-Google-Smtp-Source: APXvYqxOH8D4ZE7SXotoewPgOf+GhqHB7b/bC9fSXM70aMXHG7V34K7y28f2oxWsMOwuEjRLQ5F10Q==
X-Received: by 2002:a37:a652:: with SMTP id p79mr91353080qke.73.1559080202791;
        Tue, 28 May 2019 14:50:02 -0700 (PDT)
Received: from [10.0.0.169] ([64.26.149.125])
        by smtp.googlemail.com with ESMTPSA id e5sm1404132qkg.81.2019.05.28.14.50.01
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 May 2019 14:50:02 -0700 (PDT)
To:     people <people@netdevconf.or>
Cc:     "board@netdevconf.org" <board@netdevconf.org>,
        linux-wireless <linux-wireless@vger.kernel.org>,
        netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
        lwn@lwn.net, netdev@vger.kernel.org, lartc@vger.kernel.org
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: Announcing Netdev 0x14
Message-ID: <4e8a273f-e78b-b2cc-a8fb-7c8f423b16ff@mojatatu.com>
Date:   Tue, 28 May 2019 17:50:01 -0400
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


Folks,

Based on the feedback we received in the conducted polls,
The NetDev Society is pleased to announce that Netdev 0x14
will take place March 17-20th, 2020 in Vancouver, Canada.

The new format is:
- 3 days talks + 1 day of tutorials and workshops
- The 3 day talks will be single track talks with more breaks
and breakout rooms available for discussions.

The call for papers will open up on Tuesday, September 17, 2019.

More details will be posted here:
https://www.netdevconf.org/0x14

We are going to bring you more updates as they become available to us.
For regular updates, please subscribe to people@lists.netdevconf.org

If twitter is your thing then follow us: @netdev01
and use hashtag #netdevconf


cheers,
jamal
