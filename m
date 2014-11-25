From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat-experimental6 PATCH v2] iptables: xtables-eb:
 fix renaming of chains
Date: Tue, 25 Nov 2014 20:06:00 +0100
Message-ID: <20141125190600.GA12999@salvia>
References: <20141124184305.1910.4067.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, giuseppelng@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35580 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750887AbaKYTDy (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Nov 2014 14:03:54 -0500
Content-Disposition: inline
In-Reply-To: <20141124184305.1910.4067.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Nov 24, 2014 at 07:43:05PM +0100, Arturo Borrero Gonzalez wrote:
> Renaming of chains is not working. and ebtables-compat gets:
>  libnftnl: attribute 0 assertion failed in chain.c:159
> 
> This patch brings back the parser code of the original ebtables tool:
>  http://git.netfilter.org/ebtables.old-history/tree/userspace/ebtables2/ebtables.c#n652
> 
> I adaped the original parser code to fit in the new environment. Also tried to
> keep original error messages as much as possible.

Applied, thanks.
