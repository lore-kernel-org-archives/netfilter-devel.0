From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] xt_recent fix BUG()
Date: Sun, 16 Dec 2012 23:50:25 +0100
Message-ID: <20121216225025.GB4167@1984>
References: <50C78438.4040102@guap.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: "Vitaly E. Lavrov" <lve@guap.ru>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50324 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750713Ab2LPWu2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Dec 2012 17:50:28 -0500
Content-Disposition: inline
In-Reply-To: <50C78438.4040102@guap.ru>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Vitaly,

On Tue, Dec 11, 2012 at 11:06:32PM +0400, Vitaly E. Lavrov wrote:
> The following patch fixes a bug in xt_recent.
> Bug appears at the end of work the networks namespace, provided that
> the tables (filter/mangle/raw) have rule  with xt_recent.
> The error occurs because the __net_exit recent_net_exit() is
> executed before the tables are cleared.
> Change this order of calls is impossible, since tables must be
> registered earlier than extensions.
> Bug exists in all versions of the kernel since 2.6.35
> 
> Cleaning tables before completing the network namespace can be used
> as a workaround.
> 
> Idea of the patch that if the files are deleted from the directory
> /proc/net/xt_recent" procedure XXXXX, then a flag is set "clean".
> If cleaning the tables occurs later and the flag "clean" is set,
> then the delete files is skipped.
> 
> Patch for kernel 3.4.22

I need that the patch applies to some more recent kernel tree.

Same comment for the hashlimit fix.

Could you send me a new round rebased upon it, please? Thanks.
