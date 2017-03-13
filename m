From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: Force fake conntrack entry to be at least 8
 bytes aligned
Date: Mon, 13 Mar 2017 13:36:06 +0100
Message-ID: <20170313123606.GA14606@salvia>
References: <20170311002526.1d21e750@gandalf.local.home>
 <20170311091222.GA24201@breakpoint.cc>
 <20170313123332.GA6790@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37176 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753092AbdCMMht (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 13 Mar 2017 08:37:49 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 12012E04B6
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:37:41 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id CFF31B8012
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:37:40 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C6E0952351
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Mar 2017 13:36:06 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20170313123332.GA6790@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Mar 13, 2017 at 01:33:32PM +0100, Pablo Neira Ayuso wrote:
> On Sat, Mar 11, 2017 at 10:12:22AM +0100, Florian Westphal wrote:
> > Steven Rostedt (VMware) <rostedt@goodmis.org> wrote:
> > > Since the nfct and nfctinfo have been combined, the nf_conn structure
> > > must be at least 8 bytes aligned, as the 3 LSB bits are used for the
> > > nfctinfo. But there's a fake nf_conn structure to denote untracked
> > > connections, which is created by a PER_CPU construct. This does not
> > > guarantee that it will be 8 bytes aligned and can break the logic in
> > > determining the correct nfctinfo.
> > > 
> > > I triggered this on a 32bit machine with the following error:
> > [..]
> > 
> > Ugh.  Originally I had planned to also submit followup changes
> > to get rid of the untracked objects but that part got delayed.
> > 
> > > By using DEFINE/DECLARE_PER_CPU_ALIGNED we can enforce at least 8 byte
> > > alignment as all cache line sizes are at least 8 bytes or more.
> > 
> > Thanks for fixing this!
> > 
> > Acked-by: Florian Westphal <fw@strlen.de>
> 
> Applied, thanks.

@Florian: This is clashing with your nf-next patches to kill the fake
conntrack. Would you mind if you resubmit these once this fix shows up
in the nf-next.git tree. I'll try to expedite this.

Thanks.
