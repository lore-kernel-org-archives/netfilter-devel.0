From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf v5 2/3] netfilter: nat_helper: Make sure every proto
 nat module uses its nat_helper
Date: Fri, 14 Apr 2017 03:02:49 +0200
Message-ID: <20170414010249.GA29837@salvia>
References: <cover.1490955730.git.fgao@ikuai8.com>
 <74aaa9aaa69d65fa46d56faf5c4de671abf4a5cf.1490955730.git.fgao@ikuai8.com>
 <20170414001107.GA28754@salvia>
 <000001d2b4b8$97256c40$c57044c0$@foxmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Gao Feng <gfree.wind@foxmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39304 "EHLO mail.us.es"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1753351AbdDNBCz (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 13 Apr 2017 21:02:55 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
        by mail.us.es (Postfix) with ESMTP id D29F4E044A
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 03:02:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id C3415DA865
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 03:02:49 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
        by antivirus1-rhel7.int (Postfix) with ESMTP id 9F60CDA793
        for <netfilter-devel@vger.kernel.org>; Fri, 14 Apr 2017 03:02:47 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <000001d2b4b8$97256c40$c57044c0$@foxmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 14, 2017 at 08:46:44AM +0800, Gao Feng wrote:
> > -----Original Message-----
> > From: Pablo Neira Ayuso [mailto:pablo@netfilter.org]
> > On Fri, Mar 31, 2017 at 06:38:20PM +0800, gfree.wind@foxmail.com wrote:
> > > +static struct nf_ct_nat_helper pptp_nat = {
> > > +	.name			= "pptp_nat",
> > 
> > Why all these with "xyz_nat" names?
> 
> I just used the variable name before.
> How about rename it to "xyz_nat_helper"?
> > 
> > This is going to break ctnetlink, as this is the name that identifies the
> NAT
> > helper to be used.

This name is exposed to userspace, right?

So FTP uses to rely on the "nat-follow-master" expectfn. But now the
name will be "ftp_nat".

If that is the case, this would break backward.
