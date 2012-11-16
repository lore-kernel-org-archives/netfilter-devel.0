From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH - v2] expr: Add support for NAT expressions
Date: Fri, 16 Nov 2012 08:02:18 +0100
Message-ID: <20121116070218.GB12690@1984>
References: <1352990425-909-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37375 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750817Ab2KPHCX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 16 Nov 2012 02:02:23 -0500
Content-Disposition: inline
In-Reply-To: <1352990425-909-1-git-send-email-tomasz.bursztyka@linux.intel.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Nov 15, 2012 at 04:40:25PM +0200, Tomasz Bursztyka wrote:
> Signed-off-by: Tomasz Bursztyka <tomasz.bursztyka@linux.intel.com>
> ---
>  include/libnftables/expr.h          |   9 ++
>  include/linux/netfilter/nf_tables.h |   9 +-
>  src/Makefile.am                     |   1 +
>  src/expr/nat.c                      | 250 ++++++++++++++++++++++++++++++++++++
>  src/expr_ops.c                      |   2 +
>  5 files changed, 267 insertions(+), 4 deletions(-)
>  create mode 100644 src/expr/nat.c

Also applied the user-space side, thanks Tomasz.
