From: Harsha Sharma <harshasharmaiitr@gmail.com>
Subject: nftables: 0040set_0 test in tests/shell/testcases/transactions fails
Date: Fri, 6 Oct 2017 19:43:10 +0530
Message-ID: <CANMOCy0k-k7ZdjEAJHDeRR=A=O5BZUFVStZMtyvnWuuzqcDZmg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        outreachy-kernel <outreachy-kernel@googlegroups.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f195.google.com ([209.85.217.195]:33650 "EHLO
        mail-ua0-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751025AbdJFONL (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 6 Oct 2017 10:13:11 -0400
Received: by mail-ua0-f195.google.com with SMTP id 103so3646320uas.0
        for <netfilter-devel@vger.kernel.org>; Fri, 06 Oct 2017 07:13:11 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello all,
0040set_0 test in tests/shell/testcases/transactions fails when trying
to delete an empty chain with error "Could not process rule: Device or
resource busy".
The element referring to the chain is already deleted and the same
error occurs even after explicitly adding rule to flush the chain
before deleting it. On the other hand, everything seems to work fine
if all the rules are inputted from command line one by one whereas
same error occurs with a nft executable script .
Is this a known issue ?
What can be the reason for this if this is known ?
I hope I'm clear.
Thanks for your time.

Regards,
Harsha Sharma
