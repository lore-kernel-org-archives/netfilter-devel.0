From: Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: KASAN, xt_TCPMSS  finally found nasty use-after-free bug? 4.10.8
Date: Sun, 02 Apr 2017 05:32:24 -0700
Message-ID: <1491136344.10124.10.camel@edumazet-glaptop3.roam.corp.google.com>
References: <6c6e2f7505f969d8c2998efff24063ba@nuclearcat.com>
         <1491132259.10124.3.camel@edumazet-glaptop3.roam.corp.google.com>
         <20170402114545.GA31804@breakpoint.cc>
         <1491134084.10124.6.camel@edumazet-glaptop3.roam.corp.google.com>
         <1491135593.10124.9.camel@edumazet-glaptop3.roam.corp.google.com>
         <4442718191e17f0ff91bf1359da6d631@nuclearcat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Florian Westphal <fw@strlen.de>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        linux-kernel@vger.kernel.org, netdev-owner@vger.kernel.org
To: Denys Fedoryshchenko <nuclearcat@nuclearcat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-it0-f67.google.com ([209.85.214.67]:35473 "EHLO
        mail-it0-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751014AbdDBMc1 (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 2 Apr 2017 08:32:27 -0400
In-Reply-To: <4442718191e17f0ff91bf1359da6d631@nuclearcat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, 2017-04-02 at 15:25 +0300, Denys Fedoryshchenko wrote:
> >  	 */
> I will add also WARN_ON_ONCE(tcp_hdrlen >= 15 * 4) before, for 
> curiosity, if this condition are triggered. Is it fine like that?

Sure.


