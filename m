From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] solve musl build problem
Date: Thu, 3 Sep 2015 18:47:39 +0200
Message-ID: <20150903164739.GA21105@salvia>
References: <1441298310-3951-1-git-send-email-brendanheading@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Brendan Heading <brendanheading@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40995 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754497AbbICQlL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Sep 2015 12:41:11 -0400
Content-Disposition: inline
In-Reply-To: <1441298310-3951-1-git-send-email-brendanheading@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 03, 2015 at 05:38:30PM +0100, Brendan Heading wrote:
> musl does not include <sys/queue.h> which is a series of macros
> implementing linked lists etc. The suggestion on the part of the musl devs
> is to include a copy in the source tree. The header here is lifted from
> glibc but appears to be 3-clause BSD licensed.
> 
> Signed-off-by: Brendan Heading <brendanheading@gmail.com>
> ---
>  src/lookup_kas.c |   2 +-
>  src/main.c       |   2 +-
>  src/queue.h      | 574 +++++++++++++++++++++++++++++++++++++++++++++++++++++++
>  3 files changed, 576 insertions(+), 2 deletions(-)
>  create mode 100644 src/queue.h
> 
> diff --git a/src/lookup_kas.c b/src/lookup_kas.c
> index 09fad98..8dfad5f 100644
> --- a/src/lookup_kas.c
> +++ b/src/lookup_kas.c

Where is this file in our netfilter tree?
