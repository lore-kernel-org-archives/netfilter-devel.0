From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/3] libxt_addrtype: rename from libipt_addrtype
Date: Tue, 6 Sep 2011 13:34:44 +0200
Message-ID: <20110906113444.GA3415@1984>
References: <1315247081-12131-1-git-send-email-jengelh@medozas.de>
 <1315247081-12131-2-git-send-email-jengelh@medozas.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:47225 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753411Ab1IFLes (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Sep 2011 07:34:48 -0400
Content-Disposition: inline
In-Reply-To: <1315247081-12131-2-git-send-email-jengelh@medozas.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 05, 2011 at 08:24:38PM +0200, Jan Engelhardt wrote:
> Signed-off-by: Jan Engelhardt <jengelh@medozas.de>
> ---
>  extensions/libipt_addrtype.c   |  308 ----------------------------------------
>  extensions/libipt_addrtype.man |   69 ---------
>  extensions/libxt_addrtype.c    |  308 ++++++++++++++++++++++++++++++++++++++++
>  extensions/libxt_addrtype.man  |   69 +++++++++
>  4 files changed, 377 insertions(+), 377 deletions(-)
>  delete mode 100644 extensions/libipt_addrtype.c
>  delete mode 100644 extensions/libipt_addrtype.man
>  create mode 100644 extensions/libxt_addrtype.c
>  create mode 100644 extensions/libxt_addrtype.man

You can get smaller patches with -M option in git-format-patch. Just
to let you know for the next time you have to make some renaming.
