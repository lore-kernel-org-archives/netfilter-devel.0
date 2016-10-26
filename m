From: mark diener <rpzrpzrpz@gmail.com>
Subject: Logical processing
Date: Tue, 25 Oct 2016 23:04:05 -0600
Message-ID: <CAChgv6pFz88D_ZCn5LOPh+HvdM7kK9Tbbt46u=xFwEqRAxb9cA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-oi0-f46.google.com ([209.85.218.46]:35181 "EHLO
        mail-oi0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751143AbcJZFEH (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 26 Oct 2016 01:04:07 -0400
Received: by mail-oi0-f46.google.com with SMTP id i127so79208328oia.2
        for <netfilter-devel@vger.kernel.org>; Tue, 25 Oct 2016 22:04:07 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I am trying to understand how all the different attributes like
NFTA_CT_KEY are processed in the kernel.

Other than guessing how the kernel source actually reads and parses
and processes the attributes, is there a reference available that
gives the human understanding behind the kernel source.

I have different ops like "ct", "cmp", and "bitwise" (and others), but
want to understand the "registers" and ops.

Any suggestions appreciated.

Marco
