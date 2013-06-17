From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/3] nat: xml: fix non-mandatory element
Date: Mon, 17 Jun 2013 21:28:28 +0200
Message-ID: <20130617192828.GC13504@localhost>
References: <20130615011603.3778.67261.stgit@nfdev.cica.es>
 <20130615011610.3778.37555.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50143 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751610Ab3FQT2d (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:28:33 -0400
Content-Disposition: inline
In-Reply-To: <20130615011610.3778.37555.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 15, 2013 at 03:16:10AM +0200, Arturo Borrero wrote:
> If the node isn't present, this produces segfault.

Also applied.
