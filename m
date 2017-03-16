From: Lorenzo Colitti <lorenzo@google.com>
Subject: Re: [PATCH iptables 1/2] iptables: remove duplicated argument parsing code
Date: Thu, 16 Mar 2017 16:56:14 +0900
Message-ID: <CAKD1Yr333D6mHr50YZ4URwmyrdYkinHjWB9a0f6mEzOuDJyOyg@mail.gmail.com>
References: <20170315134553.35772-1-lorenzo@google.com> <20170315134553.35772-2-lorenzo@google.com>
 <30ea803326b87cfdc78ebe8d3b373a04@codeaurora.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Cc: netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Joel Scherpelz <jscherpelz@google.com>, zlpnobody@gmail.com
To: Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-ua0-f179.google.com ([209.85.217.179]:33484 "EHLO
        mail-ua0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1750987AbdCPH4g (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Mar 2017 03:56:36 -0400
Received: by mail-ua0-f179.google.com with SMTP id u30so21717939uau.0
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Mar 2017 00:56:35 -0700 (PDT)
In-Reply-To: <30ea803326b87cfdc78ebe8d3b373a04@codeaurora.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Mar 16, 2017 at 8:49 AM, Subash Abhinov Kasiviswanathan
<subashab@codeaurora.org> wrote:
> I am seeing a compilation failure with this patch.
> It might require a fix like below.

Fixed in v2, thanks!
