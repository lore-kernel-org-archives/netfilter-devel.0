From: Florian Westphal <fw@strlen.de>
Subject: Re: [netfilter-core] [lkp] [netfilter] 68263ddb47: WARNING: CPU: 0
 PID: 1225 at net/netfilter/nf_conntrack_seqadj.c:232
 nf_ct_seq_offset+0x7a/0x9a
Date: Sat, 17 Sep 2016 12:40:21 +0200
Message-ID: <20160917104021.GF5204@breakpoint.cc>
References: <1472780905-13094-1-git-send-email-fgao@ikuai8.com>
 <20160916140449.GB7764@yexl-desktop>
 <CA+6hz4o_Jub=zUcnXjy=oXS_5uZkxxw2Jv7p2FvdMqHV0pg+hw@mail.gmail.com>
 <20160916171827.GE5204@breakpoint.cc>
 <CA+6hz4rLzt+u8P+4rOrc3brp4kNK6DrCk546G-jGvcVPVcDmrg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Florian Westphal <fw@strlen.de>,
        kernel test robot <xiaolong.ye@intel.com>,
        Netfilter Developer Mailing List
        <netfilter-devel@vger.kernel.org>, lkp@01.org
To: Gao Feng <fgao@ikuai8.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from Chamillionaire.breakpoint.cc ([146.0.238.67]:50516 "EHLO
        Chamillionaire.breakpoint.cc" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1758731AbcIQKki (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 17 Sep 2016 06:40:38 -0400
Content-Disposition: inline
In-Reply-To: <CA+6hz4rLzt+u8P+4rOrc3brp4kNK6DrCk546G-jGvcVPVcDmrg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gao Feng <fgao@ikuai8.com> wrote:

[ drop netdev & coreteam from cc list ]

> On Sat, Sep 17, 2016 at 1:18 AM, Florian Westphal <fw@strlen.de> wrote:
> 
> > Gao Feng <fgao@ikuai8.com> wrote:
> > > > [   23.465616] ------------[ cut here ]------------
> > > > [   23.466477] WARNING: CPU: 0 PID: 1225 at net/netfilter/nf_conntrack_
> > seqadj.c:232
> > > > nf_ct_seq_offset+0x7a/0x9a
> > > > [   23.468458] Missing nfct_seqadj_ext_add() setup call
> > > >
> > >
> > > It should be that nf_ct_add_synproxy failed and the seqadj extentision is
> > > not added.
> >
> > Note that nfct_synproxy_ext_add always returns NULL if
> > CONFIG_NETFILTER_SYNPROXY=n
> >
> > The warning should also be removed.
> 
> 
> When CONFIG_NETFILTER_SYNPROXY=NULL, it will not reach
> nfct_synproxy_ext_add, because nfct_synproxy also returns the NULL.

Right.  Apologies, I did not realize this report is about an old
revision of the patch that was never applied to the tree.

So I think we can just ignore this report.

[ its this patch:
  https://patchwork.ozlabs.org/patch/665102/ ]

> I am not clear why the commit breaks conntrack when if SYNPROXY=n based on
> my response above.

Its fine, forget about it.
