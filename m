From: Ivan Babrou <ibobrik@gmail.com>
Subject: nf_nat_cleanup_conntrack performance with rhlist
Date: Wed, 6 Sep 2017 12:53:00 +0100
Message-ID: <CANWdNRCtJreq1xP2sgA=mgV8X15W1Ki-u=Ot3r1eANEVeHKRSA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: netfilter-devel@vger.kernel.org, fw@strlen.de, pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qk0-f180.google.com ([209.85.220.180]:35279 "EHLO
        mail-qk0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753268AbdIFLxb (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 6 Sep 2017 07:53:31 -0400
Received: by mail-qk0-f180.google.com with SMTP id r141so18616272qke.2
        for <netfilter-devel@vger.kernel.org>; Wed, 06 Sep 2017 04:53:31 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

We hit a bug where nf_nat_cleanup_conntrack is taking exponential amount of time
if you ping a lot of distinct IPs. It seems to be related to hlist ->
rhlist migration.

Here's the bugzilla ticket:

* https://bugzilla.kernel.org/show_bug.cgi?id=196821

It has a reproduce script and the list of reverts that bring back
reasonable performance.

Dev mailing list seems like a good place to notify the right people.

The first email got rejected because of html subpart, apologies for
the duplicate.

Thanks.
