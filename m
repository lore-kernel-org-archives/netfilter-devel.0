From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] include: add linux/filter.h
Date: Wed, 30 Jul 2014 18:23:25 +0200
Message-ID: <20140730162325.GA4669@salvia>
References: <1406672342-4306-1-git-send-email-willemb@google.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Willem de Bruijn <willemb@google.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59402 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755574AbaG3QXL (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 30 Jul 2014 12:23:11 -0400
Content-Disposition: inline
In-Reply-To: <1406672342-4306-1-git-send-email-willemb@google.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jul 29, 2014 at 06:19:02PM -0400, Willem de Bruijn wrote:
> xt_bpf.h includes linux/filter.h for the definition of sock_filter.
> add that file to the repository

Applied to the iptables repo, thanks Willem.

