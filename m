From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 1/3] nat: xml: fix xml_snprintf buffer offset
Date: Mon, 17 Jun 2013 21:28:07 +0200
Message-ID: <20130617192807.GB13504@localhost>
References: <20130615011603.3778.67261.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50100 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753115Ab3FQT2L (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 17 Jun 2013 15:28:11 -0400
Content-Disposition: inline
In-Reply-To: <20130615011603.3778.67261.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 15, 2013 at 03:16:03AM +0200, Arturo Borrero wrote:
> This patch fix the buffer offset of the nat snprintf function,
> so elements are properly printed.

Applied, thanks.

I would like to have more XML test in this tree.

Instead of the current .sh scripts, we should have a large list of
.xml files under libnftables/test/ with the different compositions
that we support.

Then, you can make a script that iterates over the list of existing
.xml files in that directory and it stops if the test fails.
