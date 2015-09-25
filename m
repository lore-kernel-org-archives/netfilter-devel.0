From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: =?utf-8?B?562U5aSNOiBbUEFUQ0hdOiBuZXRm?=
 =?utf-8?Q?ilter=3A_ftp=2Firc=2Fsane=2Fsip=2Ftftp=3A_Fix_th?= =?utf-8?Q?e?=
 kernel panic when load these modules with duplicated ports
Date: Fri, 25 Sep 2015 13:20:28 +0200
Message-ID: <20150925112028.GA7930@salvia>
References: <BAY403-EAS55DEFB461D662C9DA7662795420@phx.gbl>
 <BAY403-EAS49051FE98EBBE5A72C2E2695420@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Feng Gao <gfree.wind@outlook.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47880 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752523AbbIYLNj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 25 Sep 2015 07:13:39 -0400
Content-Disposition: inline
In-Reply-To: <BAY403-EAS49051FE98EBBE5A72C2E2695420@phx.gbl>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 25, 2015 at 07:12:24PM +0800, Feng Gao wrote:
> Hi Pablo,
> 
> When execute " insmod nf_conntrack_ftp.ko ports=76,76,76", the kernel
> crashes immediately.
> Because the old codes try to unregister the helper which is not registered
> successfully.
> This bug has existed for a long time since the nf_conntrack_helper_register
> checked the duplicated entry.
> 
> I don't know if I should add the reproduce process in the commit comment.

That's good idea to insist on the fact that this bug is crashing the
kernel, and that is not good.
