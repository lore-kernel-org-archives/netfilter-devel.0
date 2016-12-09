From: Christos <christos@tsopokis.gr>
Subject: Question on match pid owner
Date: Fri, 9 Dec 2016 18:05:47 +0000
Message-ID: <336e4de5-d75d-e936-613a-1ee07f2e6c53@tsopokis.gr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f52.google.com ([74.125.82.52]:36167 "EHLO
        mail-wm0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1752976AbcLISFv (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 9 Dec 2016 13:05:51 -0500
Received: by mail-wm0-f52.google.com with SMTP id g23so34013451wme.1
        for <netfilter-devel@vger.kernel.org>; Fri, 09 Dec 2016 10:05:50 -0800 (PST)
Received: from ?IPv6:2a02:c7f:c408:4b00:193f:8a64:bb16:593e? ([2a02:c7f:c408:4b00:193f:8a64:bb16:593e])
        by smtp.gmail.com with ESMTPSA id j1sm43506710wjm.26.2016.12.09.10.05.48
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Fri, 09 Dec 2016 10:05:48 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there,

recently I started working on developing a userspace packet inspection 
daemon for personal use via netfilter queues. However, I want to 
validate the identity of the originating process and I've seen that the 
--pid-owner option is not available any more. That means that I will 
probably move by developing a netfilter module or working on the 
existing one.

However, I would like to ask what is the reason for which the option has 
been removed and what could be corrected in the existing match module to 
make it functional and reliable again. Were there any edge cases that 
caused it to misbehave? With a little bit of guidance, I believe I can 
help on that if my assistance is welcome and the project considered 
worth enough.

Thanks,
