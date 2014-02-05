From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC libnftnl PATCH 0/2] New mnlio functions
Date: Wed, 5 Feb 2014 19:24:01 +0000
Message-ID: <20140205192401.GA9077@macbook.localnet>
References: <20140205191711.9979.23980.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, pablo@netfilter.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:59384 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751384AbaBETYJ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 5 Feb 2014 14:24:09 -0500
Content-Disposition: inline
In-Reply-To: <20140205191711.9979.23980.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 05, 2014 at 08:17:41PM +0100, Arturo Borrero Gonzalez wrote:
> These functions are likely to be reused by almost all programs
> that want to talk with the kernel subsystem.
> 
> We can add here to libnftnl or maybe put in a higher level library.
> 
> Let this patchset be a RFC about this subject.
> 
> An example of what means using the new mnlio approach is the
> examples/nft-rule-add.c file. We save lots of LOCs.
> 
> Comments welcome.

I agree, they belong in libnftnl. Thanks for doing this work.

> 
> NOTE: this patchset would require several iterations. For example,
> I left behind batch_pages.
> ---
> 
> Arturo Borrero Gonzalez (2):
>       src: add mnlio API functions
>       examples: use new mnlio API in nft-rule-add.c
> 
> 
>  examples/nft-rule-add.c      |   87 ----
>  include/libnftnl/Makefile.am |    3 
>  include/libnftnl/mnlio.h     |   92 ++++
>  src/Makefile.am              |    1 
>  src/libnftnl.map             |   37 ++
>  src/mnlio.c                  |  957 ++++++++++++++++++++++++++++++++++++++++++
>  6 files changed, 1096 insertions(+), 81 deletions(-)
>  create mode 100644 include/libnftnl/mnlio.h
>  create mode 100644 src/mnlio.c
