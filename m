From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: Thanks to netfilter project
Date: Mon, 6 Mar 2017 19:26:09 +0100
Message-ID: <CAOkSjBgsci5CxwOe43uw4jQEJhRsecHnVyfoa_Kbyob9j5tDXA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
To: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f51.google.com ([209.85.214.51]:38030 "EHLO
        mail-it0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S932222AbdCFScw (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 6 Mar 2017 13:32:52 -0500
Received: by mail-it0-f51.google.com with SMTP id m27so56111322iti.1
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Mar 2017 10:32:51 -0800 (PST)
Received: from mail-it0-f51.google.com (mail-it0-f51.google.com. [209.85.214.51])
        by smtp.gmail.com with ESMTPSA id 198sm9007321ioz.59.2017.03.06.10.26.30
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 06 Mar 2017 10:26:30 -0800 (PST)
Received: by mail-it0-f51.google.com with SMTP id m27so55987032iti.1
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Mar 2017 10:26:30 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi folks,

I have been successfully running a production nftables firewall
cluster for 2 months now with no issues so far.

I use many of the new features: sets, mappings, concatenations... The
nftables system is integrated with other netfilter stuff, like
conntrackd, ulogd, et all.

Traffic with peaks of ~2Gbps. Not that much, but still. I will try to
migrate another firewall this year which sees even more traffic.

Thanks to Pablo, Florian and all the rest of the Netfilter community
who made this possible :-)
