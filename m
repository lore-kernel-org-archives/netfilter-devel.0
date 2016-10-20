From: Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH nf-next 0/3] netfilter: built-in NAT support for DCCP,
 SCTP, UDPlite
Date: Thu, 20 Oct 2016 12:36:48 +0200
Message-ID: <1476959808.2842.7.camel@redhat.com>
References: <cover.1476956422.git.dcaratti@redhat.com>
         <20161020102808.GB26517@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:44318 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1758088AbcJTKgw (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 06:36:52 -0400
In-Reply-To: <20161020102808.GB26517@breakpoint.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2016-10-20 at 12:28 +0200, Florian Westphal wrote:

> Sorry for not thinking of this sooner, but it would be nice to record
> size increase of nat module in the commit message (and perhaps size of
> 'old' proto_foo nat module that is removed).

hi,

yes - it makes sense. I will reword and post a v2 with test results.
regards,
--
davide
