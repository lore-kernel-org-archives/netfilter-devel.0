Return-Path: <SRS0=bjic=4D=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,PDS_TONAME_EQ_TOLOCAL_SHORT,
	SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 95CF7C7114E
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Feb 2020 21:52:24 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 661642084E
	for <netfilter-devel@archiver.kernel.org>; Sat, 15 Feb 2020 21:52:24 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=mojatatu-com.20150623.gappssmtp.com header.i=@mojatatu-com.20150623.gappssmtp.com header.b="lro82BIj"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727635AbgBOVwF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 15 Feb 2020 16:52:05 -0500
Received: from mail-qk1-f182.google.com ([209.85.222.182]:36905 "EHLO
        mail-qk1-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726275AbgBOVwF (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 15 Feb 2020 16:52:05 -0500
Received: by mail-qk1-f182.google.com with SMTP id c188so12746465qkg.4
        for <netfilter-devel@vger.kernel.org>; Sat, 15 Feb 2020 13:52:02 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=to:cc:from:subject:message-id:date:user-agent:mime-version
         :content-language:content-transfer-encoding;
        bh=hmW9uUExBD5bXGwCqUZfBGtN7UxUxJa7T9gal2J1nMw=;
        b=lro82BIjIt71jSDjx5dHHbzh9O7aWp2UMOhqlTodsz9vML6UAGUeWuq66gk4vMa1KM
         wB7ttSJCtBHspGgnZPdTVXtbh9eZFi0tBEOSohR7w9BHcNOEAS9P0JocqitohUb0uj2n
         hdDVVINV98Ki8IBwknAUb+57kO5dnP4TazBiZ7vvMdlExyyaxuF+5j33v+mXAqoSeDvk
         I5DmHX0aLCXHGqiYXMRxF1G4Ye7Y778xR4Qg/0LMzfopYYsNXICdUhvZZrQa4E91qOV+
         iRKVQIGb6GSQs6Y2gLetjtuksfSzS/MioAjxvOaX6XRJsXg/8XmH8IptWavD0VTLAslc
         TUaQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:cc:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=hmW9uUExBD5bXGwCqUZfBGtN7UxUxJa7T9gal2J1nMw=;
        b=em/8Lg/PtLDe19xGSu7AncdEn642o1ec7IWgIZ/d/Dhru6/h3oZsKBzvKjtmaJaOLn
         OUYB5fP02AAYspRm8OOLtIMr1tQ2U4c6AFNeew+O52hiddljkCHue0Tne/bXqnudoDaB
         ENRg222+RPAnbrg6O93AAQqkIk+hElgPbQOf7BjmnK2ZRqaICMTfhVgCndmwDgnkC9it
         5z70os0p3xqp73rFYHnLwzPXIiRbSaulnOCwQjvf2XndeTt4Hds8qDX6pMzaFq5l6KG3
         Z408t8bvw3udayi+SbJhZgLxlqrOzgHvz3CMlTZZ5+S/67zqJMf/hj8M7Ofm8pEum1Jm
         MxoA==
X-Gm-Message-State: APjAAAUGgx1ZxLzVd+Aa6owUogeVMw3eMCvMqmXGKfEDkImXlLdGSknf
        lZe+ti1wIDjM1CLyX+5Y/Mwm98Z2h5wI3m0s
X-Google-Smtp-Source: APXvYqxoANsLhigIQHncTXQO+p9XZM6WRd9+aMZr6+BLHAH7am9ZHGovaz09CyjBIK2DzMSZVwOwpg==
X-Received: by 2002:a37:3c5:: with SMTP id 188mr8428230qkd.312.1581803522429;
        Sat, 15 Feb 2020 13:52:02 -0800 (PST)
Received: from [192.168.43.235] ([204.48.77.136])
        by smtp.googlemail.com with ESMTPSA id o17sm6004607qtq.93.2020.02.15.13.52.01
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 13:52:01 -0800 (PST)
To:     people <people@netdevconf.info>
Cc:     prog-committee-0x14@netdevconf.info, speakers-0x14@netdevconf.info,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>, lwn@lwn.net,
        netfilter-devel@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        lartc@vger.kernel.org, Christie Geldart <christie@ambedia.com>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Subject: 0x14: Schedule out!
Message-ID: <c8d8a7be-834e-1bab-9c6e-fa6f39ea6040@mojatatu.com>
Date:   Sat, 15 Feb 2020 16:52:00 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.2
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


We are pleased to announce the tentative schedule
for 0x14. There may be some minor changes
going forward - but the overall theme will remain.

For the schedule and logistics please see:
https://netdevconf.info/0x14/news.html?schedule-up

Come one, come all!
Again, as a reminder - 2 days to go for end of
early bird registration. See:
https://netdevconf.info/0x14/registration.html

cheers,
jamal
