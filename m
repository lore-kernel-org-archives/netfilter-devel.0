From: Davide Caratti <dcaratti@redhat.com>
Subject: Re: [PATCH nf-next 1/3] netfilter: built-in NAT support for DCCP
Date: Thu, 20 Oct 2016 18:30:10 +0200
Message-ID: <1476981010.2842.10.camel@redhat.com>
References: <cover.1476956422.git.dcaratti@redhat.com>
         <96409ea5aa35dd371f7ad0efa622339f82318b24.1476956422.git.dcaratti@redhat.com>
         <20161020123726.GA10040@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:49266 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1755211AbcJTQaP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 12:30:15 -0400
In-Reply-To: <20161020123726.GA10040@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, 2016-10-20 at 14:37 +0200, Pablo Neira Ayuso wrote:
> I think you can replace this by:
> 
> #ifdef CONFIG_NF_NAT_PROTO_DCCP
> 
> given that IS_ENABLED catches the module case too.

That's right, so all IS_ENABLED(...) are going to be replaced with #ifdef
... in v2.

regards,
--
davide

