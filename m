From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: net/sctp: vmalloc allocation failure in
 sctp_setsockopt/xt_alloc_table_info
Date: Mon, 28 Nov 2016 10:26:40 -0800
Message-ID: <1480357600.18162.74.camel@edumazet-glaptop3.roam.corp.google.com>
References: <CAAeHK+wecw6ST_DWJQBLFNwVsOVgderGE-EEJiN0-kf796XHtw@mail.gmail.com>
         <20161128141340.GA29839@hmsreliant.think-freely.org>
         <CAAeHK+xJmwF6hddS-sO-y3HQkRicwQN=ZceFWTZT2M_0h4E2hQ@mail.gmail.com>
         <20161128143931.GB29839@hmsreliant.think-freely.org>
         <20161128151312.GA13172@localhost.localdomain>
         <20161128174647.GC29839@hmsreliant.think-freely.org>
         <20161128174710.GE28510@breakpoint.cc>
         <20161128175626.GD29839@hmsreliant.think-freely.org>
         <20161128180925.GF28510@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pg0-f65.google.com ([74.125.83.65]:34221 "EHLO
        mail-pg0-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1753896AbcK1S1n (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 28 Nov 2016 13:27:43 -0500
In-Reply-To: <20161128180925.GF28510@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2016-11-28 at 19:09 +0100, Florian Westphal wrote:

> We should prevent OOM killer from running in first place (GFP_NORETRY should work).

Make sure that a vmalloc(80000) will succeed, even if few pages need to
be swapped out.

Otherwise, some scripts using iptables will die while they where okay
before ?

I am not sure how GFP_NORETRY really works among different linux
kernels.

Maybe this flag has no effect for order-0 allocations anyway.


