From: Liping Zhang <zlpnobody@gmail.com>
Subject: Re: [PATCH iptables] xtables: Remove unused macro
Date: Tue, 28 Feb 2017 07:23:59 +0800
Message-ID: <CAML_gOeKq1Xfr-RBQd_bsCzuhzW-iW0WeG_PAksCYveDgfkEOQ@mail.gmail.com>
References: <1488227622-2623-1-git-send-email-subashab@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f173.google.com ([209.85.217.173]:35006 "EHLO
        mail-ua0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751547AbdB1B0u (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 27 Feb 2017 20:26:50 -0500
Received: by mail-ua0-f173.google.com with SMTP id 40so76704924uau.2
        for <netfilter-devel@vger.kernel.org>; Mon, 27 Feb 2017 17:26:33 -0800 (PST)
In-Reply-To: <1488227622-2623-1-git-send-email-subashab@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

2017-02-28 4:33 GMT+08:00 Subash Abhinov Kasiviswanathan
<subashab@codeaurora.org>:
> Minor change to remove the unused macro added as part of commit
> e8f857a5a1514c3e7d0d8ea0f7d2d571f0e37bd1 ("xtables: Add an interval
> option for xtables lock wait")
[...]
> -#define BASE_MICROSECONDS      100000

I had already sent a patch to fix a issue introduced by commit
e8f857a5a1 ("xtables: Add an interval option for xtables lock wait"),
including this tiny modification, you can refer to this:

http://patchwork.ozlabs.org/patch/724242/
