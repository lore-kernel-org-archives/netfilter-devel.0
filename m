Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-5.3 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B48C433E6
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Jan 2021 12:22:40 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 06D382075B
	for <netfilter-devel@archiver.kernel.org>; Mon,  4 Jan 2021 12:22:39 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726396AbhADMW3 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 4 Jan 2021 07:22:29 -0500
Received: from mail-wr1-f44.google.com ([209.85.221.44]:46833 "EHLO
        mail-wr1-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726308AbhADMW3 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Jan 2021 07:22:29 -0500
Received: by mail-wr1-f44.google.com with SMTP id d13so31940673wrc.13
        for <netfilter-devel@vger.kernel.org>; Mon, 04 Jan 2021 04:22:13 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:to:from:subject:message-id:date:user-agent
         :mime-version:content-language:content-transfer-encoding;
        bh=npDZbC3kM51pbDmQhBiSrbxAMM7VkzceqRbHtT+ED4E=;
        b=WrFunjOzKHwvXFsU1QT8rzM6DSS5HiIV3uk8CcNlfSTa1th7wn0njJz8RtKfYhneUi
         ZJt0tuhsd74kSuSSeAtilPLGU8zqdewejEGcXnB9DnRnG1gdUt0hUpLtvHc6JkF7tX/g
         kktFtY3UKQt93An1498DeTpdbKLvjEzkIoHi87zLpXjMHWjmFyUBDFOsRufYgCnMgqMh
         kuG0JMXl4qQu/y822r/Mqfm+uWgSb/MUm11x3RP6cJJ/Go9VleqzU/IGA8kEi/a7WsqX
         J2/3wAJolDvp8mwNlAWX3a53hK8qGeUEx+zofqx7WEctu4DJRSXdKB3FazSOzK6zgTZ9
         fgsQ==
X-Gm-Message-State: AOAM533a++KE6zMOR7u2Eruu83Uy97g5/9GxTCmvPIVaxWsqasMpkXec
        svnXBSjIpumxCVwr6EevzGwn2KwedA3ST9mO
X-Google-Smtp-Source: ABdhPJz91KUh8WIFRMzlFqeHskEzoRMeo8AQCkPkrjMiCqsS1XWY+4a6hw1EiAx6dvsN45BCTsrXug==
X-Received: by 2002:adf:fa02:: with SMTP id m2mr78462621wrr.130.1609762907820;
        Mon, 04 Jan 2021 04:21:47 -0800 (PST)
Received: from [10.239.43.214] (79.red-80-24-233.staticip.rima-tde.net. [80.24.233.79])
        by smtp.gmail.com with ESMTPSA id p9sm34509037wmm.17.2021.01.04.04.21.46
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 04 Jan 2021 04:21:46 -0800 (PST)
To:     "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>
From:   Arturo Borrero Gonzalez <arturo@netfilter.org>
Subject: Potential licensing issue with libreadline
Message-ID: <8146169e-57f5-0912-becf-e27b64051177@netfilter.org>
Date:   Mon, 4 Jan 2021 13:21:46 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.5.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

the debian nftables package got a bug report about a potential licensing issue 
related to libreadline. More info here:

https://bugs.debian.org/979103 Legally problematic GPL-3+ readline dependency

This may or may not be a Debian-specific problem, but I wanted to notify you and 
collect your ideas before trying to work out a solution myself.

Happy new year!
