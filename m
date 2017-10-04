From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: nftables: Add support for reserved header and addrs for routing
 header type 0
Date: Wed, 04 Oct 2017 12:37:26 +0530
Message-ID: <1507100846.10633.17.camel@harryPotter>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: outreachy-kernel@googlegroups.com, harshasharmaiitr@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:33965 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750866AbdJDHJ2 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 03:09:28 -0400
Received: by mail-pg0-f65.google.com with SMTP id u27so12302578pgn.1
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Oct 2017 00:09:28 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
I'm working on task for adding support for reserved header and addrs for
routing header type 0 in nftables. The code already uses macros like
[RT0HDR_RESERVED], [RT0HDR_ADDR_1] in extensions/exthdr.c but they are
not declared in parser_bison.c like other macros [RTHDR_TYPE] and
[RTHDR_NEXTHDR].
Can anyone please guide me on how to declare macros in parser_bison.c?
Thanks for your time.

Regards,
Harsha Sharma

