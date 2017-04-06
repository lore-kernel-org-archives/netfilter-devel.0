From: "Gao Feng" <gfree.wind@foxmail.com>
Subject: RE: [PATCH nf-next 1/1] netfilter: Remove useless variable timeouts in init_conntrack
Date: Thu, 6 Apr 2017 08:45:12 +0800
Message-ID: <002001d2ae6f$0d6e48e0$284adaa0$@foxmail.com>
References: <1491367754-16976-1-git-send-email-gfree.wind@foxmail.com> <20170405131728.GA15315@breakpoint.cc>
Mime-Version: 1.0
Content-Type: text/plain;
        charset="US-ASCII"
Content-Transfer-Encoding: 7bit
Cc: <pablo@netfilter.org>, <netfilter-devel@vger.kernel.org>
To: "'Florian Westphal'" <fw@strlen.de>, <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtpbguseast2.qq.com ([54.204.34.130]:52804 "EHLO
        smtpbguseast2.qq.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1751655AbdDFApS (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 5 Apr 2017 20:45:18 -0400
In-Reply-To: <20170405131728.GA15315@breakpoint.cc>
Content-Language: zh-cn
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Florian,

> -----Original Message-----
> From: Florian Westphal [mailto:fw@strlen.de]
> Sent: Wednesday, April 5, 2017 9:17 PM
> To: gfree.wind@foxmail.com
> Cc: pablo@netfilter.org; netfilter-devel@vger.kernel.org; Gao Feng
> <fgao@ikuai8.com>
> Subject: Re: [PATCH nf-next 1/1] netfilter: Remove useless variable
timeouts in
> init_conntrack
> 
> gfree.wind@foxmail.com <gfree.wind@foxmail.com> wrote:
> > From: Gao Feng <fgao@ikuai8.com>
> >
> > All l4_proto->new callbacks don't use the param timeouts currently, so
> > remove it from param list. Then the variable timeouts isn't used as
> > right value in init_conntrack, so remove it too.
> > Signed-off-by: Gao Feng <fgao@ikuai8.com>
> > ---
> >  include/net/netfilter/nf_conntrack_l4proto.h |  2 +-
> > net/ipv4/netfilter/nf_conntrack_proto_icmp.c |  2 +-
> >  net/netfilter/nf_conntrack_core.c            | 13 ++-----------
> >  net/netfilter/nf_conntrack_proto_dccp.c      |  2 +-
> >  net/netfilter/nf_conntrack_proto_sctp.c      |  2 +-
> >  net/netfilter/nf_conntrack_proto_tcp.c       |  2 +-
> >  net/netfilter/nf_conntrack_proto_udp.c       |  2 +-
> >  7 files changed, 8 insertions(+), 17 deletions(-)
> 
> What about net/netfilter/nf_conntrack_proto_gre.c ?
It's my fault.
I only checked the protos in nf_conntrack_ipv4.h.

Best Regards
Feng




