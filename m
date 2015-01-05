From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft-sync PATCH 2/3] mnl: sync source code with nft
Date: Mon, 5 Jan 2015 12:29:10 +0100
Message-ID: <20150105112910.GB13289@salvia>
References: <20141226125122.16382.30213.stgit@nfdev.cica.es>
 <20141226125127.16382.40927.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56337 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753148AbbAEL0Z (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:26:25 -0500
Content-Disposition: inline
In-Reply-To: <20141226125127.16382.40927.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 26, 2014 at 01:51:28PM +0100, Arturo Borrero Gonzalez wrote:
> Let's update the mnl source code to match the latest in nft.

Please, split this in smaller patches, it's good to keep track of the
git history when looking at the past.

> Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> ---
>  include/linux/netfilter/nf_tables.h |  125 +++++++++++++++++++++-
>  include/mnl.h                       |    2 
>  include/utils.h                     |    9 ++
>  src/main.c                          |    2 
>  src/mnl.c                           |  198 ++++++++++++++++++++++-------------
>  src/utils.c                         |    7 +
>  6 files changed, 261 insertions(+), 82 deletions(-)
> 
> diff --git a/include/linux/netfilter/nf_tables.h b/include/linux/netfilter/nf_tables.h
> index 11d5937..832bc46 100644
> --- a/include/linux/netfilter/nf_tables.h
> +++ b/include/linux/netfilter/nf_tables.h
[...]

At least this one should come in an initial patch to refresh the
cached header.

We should also start abstracting and moving things to the library in a
way that nft-sync can reuse, so we avoid code redundancy.
