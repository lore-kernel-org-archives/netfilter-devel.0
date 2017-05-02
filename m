From: Arturo Borrero Gonzalez <arturo@debian.org>
Subject: migrating from iptables to nftables
Date: Tue, 2 May 2017 10:51:52 +0200
Message-ID: <CAOkSjBgnddURksjST5BDmVebdHT-rUH6Za=-XkVPjXLCF=JPuQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
        <netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-io0-f179.google.com ([209.85.223.179]:34342 "EHLO
        mail-io0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751015AbdEBIwO (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 2 May 2017 04:52:14 -0400
Received: by mail-io0-f179.google.com with SMTP id a103so148373054ioj.1
        for <netfilter-devel@vger.kernel.org>; Tue, 02 May 2017 01:52:13 -0700 (PDT)
Received: from mail-io0-f174.google.com (mail-io0-f174.google.com. [209.85.223.174])
        by smtp.gmail.com with ESMTPSA id t136sm611925ita.22.2017.05.02.01.52.12
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 02 May 2017 01:52:12 -0700 (PDT)
Received: by mail-io0-f174.google.com with SMTP id o22so19549865iod.0
        for <netfilter-devel@vger.kernel.org>; Tue, 02 May 2017 01:52:12 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi all,

Debian is about to release Stretch stable. Given this is our first
release officially including nftables and the translate/compat tools
and we will recommend users to move from iptables to nftables I would
like to direct users to robust docs.

I wrote this [0] in Dec 2016 and I would like to make sure is
up-to-dated and accurate before "massively" pointing to it from the
debian release docs.

The debian stable release kernel is 4.9 and more recent will be
included in stable-backports (4.10 is in debian already, but not for
the stable relase). So, I wouldn't fear of users living with old
versions (hey, easy update paths are in place)

Any comments welcome.

thanks!

[0] https://wiki.nftables.org/wiki-nftables/index.php/Moving_from_iptables_to_nftables
