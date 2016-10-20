From: Florian Westphal <fw@strlen.de>
Subject: Re: [PATCH nf-next 0/3] netfilter: built-in NAT support for DCCP,
 SCTP, UDPlite
Date: Thu, 20 Oct 2016 12:28:08 +0200
Message-ID: <20161020102808.GB26517@breakpoint.cc>
References: <cover.1476956422.git.dcaratti@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
        Patrick McHardy <kaber@trash.net>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        "David S. Miller" <davem@davemloft.net>,
        Arturo Borrero Gonzalez <arturo@debian.org>,
        Florian Westphal <fw@strlen.de>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org
To: Davide Caratti <dcaratti@redhat.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:60696 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1754041AbcJTK3Y (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 20 Oct 2016 06:29:24 -0400
Content-Disposition: inline
In-Reply-To: <cover.1476956422.git.dcaratti@redhat.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Davide Caratti <dcaratti@redhat.com> wrote:
> The above L4 protocols usually need an explicit modprobe command (e.g
> "modprobe nf_nat_proto_sctp") to provide full functionality of REDIRECT
> targets and SNAT/DNAT targets where port number translation is explicitly
> configured.
> In order to remove such limitation, this series converts 
> CONFIG_NF_NAT_PROTO_{DCCP,SCTP,UDPLITE} from tristate to boolean: in case 
> NAT support for these protocols is enabled in the kernel configuration, it
> will be built into nf_nat.ko.

Sorry for not thinking of this sooner, but it would be nice to record
size increase of nat module in the commit message (and perhaps size of
'old' proto_foo nat module that is removed).
