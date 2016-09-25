From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3 2/2] netfilter: Create revision 2 of xt_hashlimit to
 support higher pps rates
Date: Sun, 25 Sep 2016 14:58:45 +0200
Message-ID: <20160925125845.GA11537@salvia>
References: <20160922164344.GB20423@akamai.com>
 <alpine.LSU.2.20.1609221850530.27197@nerf40.vanv.qr>
 <57E42571.1060502@akamai.com>
 <20160925113501.GD8331@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Jan Engelhardt <jengelh@inai.de>, kaber@trash.net,
        kadlec@blackhole.kfki.hu, johunt@akamai.com,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, pai.vishwain@gmail.com
To: Vishwanath Pai <vpai@akamai.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50654 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S966277AbcIYM67 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 25 Sep 2016 08:58:59 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id 4C643ED08C
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 14:58:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 29253DA84D
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 14:58:57 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 254BBDA81C
        for <netfilter-devel@vger.kernel.org>; Sun, 25 Sep 2016 14:58:55 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160925113501.GD8331@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Sep 25, 2016 at 01:35:01PM +0200, Pablo Neira Ayuso wrote:
> On Thu, Sep 22, 2016 at 02:39:45PM -0400, Vishwanath Pai wrote:
> > Thanks for pointing this out, I will reorder the fields to:
> > 
> > struct hashlimit_cfg2 {
> > 	__u64 avg;    /* Average secs between packets * scale */
> > 	__u64 burst;
> > 	__u32 mode; /* bitmask of XT_HASHLIMIT_HASH_* */
> > 
> > This should fix the hole and avoid padding.
> 
> I have manually mangled this here, and applied, to get this change in
> this in merge window.
> 
> I also have to revert the rename of XT_HASHLIMIT_SCALE to
> XT_HASHLIMIT_SCALE_v1. This is exposed through uapi, this change would
> break userspace.

This requires that you rebase and resubmit your userspace patches for
iptables though.

Thanks for your patience to get this in, btw.
