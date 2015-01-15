From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH 1/2 v2] src: not create iterator with empty list
Date: Thu, 15 Jan 2015 13:10:24 +0100
Message-ID: <20150115121024.GA6459@salvia>
References: <1421070375-1057-1-git-send-email-alvaroneay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Alvaro Neira Ayuso <alvaroneay@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:35244 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753259AbbAOMHc (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 15 Jan 2015 07:07:32 -0500
Content-Disposition: inline
In-Reply-To: <1421070375-1057-1-git-send-email-alvaroneay@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 12, 2015 at 02:46:14PM +0100, Alvaro Neira Ayuso wrote:
> Now, we create iterator without test if the list is empty. If the list
> is empty, we have a crash when we set up the current element.
> With this patch, we test if the list is empty before to create the iterator. If
> the list is empty the iterator return NULL.

Applied, thanks.
