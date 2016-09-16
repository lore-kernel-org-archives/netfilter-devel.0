From: Christophe Leroy <christophe.leroy@c-s.fr>
Subject: rate limit not working ?
Date: Fri, 16 Sep 2016 18:50:22 +0200
Message-ID: <a6f9f673-8c5b-4a95-ea38-4fb8b39d4dc8@c-s.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from pegase1.c-s.fr ([93.17.236.30]:29433 "EHLO pegase1.c-s.fr"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1754848AbcIPQu0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 16 Sep 2016 12:50:26 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi

I tried to limit ping flooding by setting the following rule:

nft add rule filter input icmp type echo-request limit rate 10/second accept

But it doesn't work, I can still ping flood the target.
What I see is that nft_limit_pkts_eval() is called only once at the 
begining of the flood.
After, during do_nft_chain(), regs.verdict.code is changed from -1 to 1 
by a call to nft_immediate_eval() earlier in the loop.

How can I investigate that issue ?

Using linux kernel 4.4.21

Christophe


