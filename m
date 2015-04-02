From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH -nf] netfilter: x_tables: fix cgroup matching on non-full
 sks
Date: Thu, 2 Apr 2015 10:52:38 +0200
Message-ID: <20150402085238.GB18386@salvia>
References: <63c15d588bb75294ed013671be1aff791126d142.1427479072.git.daniel@iogearbox.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org,
	Alexey Perevalov <a.perevalov@samsung.com>
To: Daniel Borkmann <daniel@iogearbox.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44030 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752315AbbDBIsc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Apr 2015 04:48:32 -0400
Content-Disposition: inline
In-Reply-To: <63c15d588bb75294ed013671be1aff791126d142.1427479072.git.daniel@iogearbox.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Mar 27, 2015 at 07:37:41PM +0100, Daniel Borkmann wrote:
> While originally only being intended for outgoing traffic, commit
> a00e76349f35 ("netfilter: x_tables: allow to use cgroup match for
> LOCAL_IN nf hooks") enabled xt_cgroups for the NF_INET_LOCAL_IN hook
> as well, in order to allow for nfacct accounting.
> 
> Besides being currently limited to early demuxes only, commit
> a00e76349f35 forgot to add a check if we deal with full sockets,
> i.e. in this case not with time wait sockets. TCP time wait sockets
> do not have the same memory layout as full sockets, a lower memory
> footprint and consequently also don't have a sk_classid member;
> probing for sk_classid member there could potentially lead to a
> crash.

Mangled this patch and applied to nf-next. I'll pass this to -stable
using this as backport. Thanks.
