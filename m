From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf_tables PATCH v2] Subject: netfilter: nf_tables: add set_elem
 notifications
Date: Tue, 8 Apr 2014 10:37:53 +0200
Message-ID: <20140408083753.GA5345@localhost>
References: <20140403135836.2769.2196.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:33975 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756319AbaDHIiF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Apr 2014 04:38:05 -0400
Content-Disposition: inline
In-Reply-To: <20140403135836.2769.2196.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Apr 03, 2014 at 03:58:58PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds set_elems notifications. When a set_elem is
> added/deleted, all listening peers in userspace will receive the
> corresponding notification.

Applied, thanks Arturo.
