From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: nftables: Add support for unsupported codes in icmp and icmp6
 extensions
Date: Wed, 04 Oct 2017 15:22:40 +0530
Message-ID: <1507110760.6328.16.camel@harryPotter>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: outreachy-kernel@googlegroups.com, harshasharmaiitr@gmail.com
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pf0-f195.google.com ([209.85.192.195]:38461 "EHLO
        mail-pf0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751114AbdJDJyo (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 4 Oct 2017 05:54:44 -0400
Received: by mail-pf0-f195.google.com with SMTP id a7so11927142pfj.5
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Oct 2017 02:54:44 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,
I am trying to add support for unsupported codes in icmp and icmp6
extensions. Like in iptables, various icmp and icmp6 codes are defined
with their type, code_min and code_max but in nftables various icmp and
icmp6 codes are defined only with their type so codes for unreach,
redirect and time-exceeded are not supported as some of their type
values mismatches otherwise.
Can someone please guide me on what will be the best way to add support
for unreach, redirect and time-exceeded codes in icmp and icmp6
extensions in nftables.
Thanks for your time.

Regards,
Harsha Sharma

