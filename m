From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nft-sync PATCH 3/3] client: parse ruleset before printing
Date: Mon, 5 Jan 2015 12:30:22 +0100
Message-ID: <20150105113022.GC13289@salvia>
References: <20141226125122.16382.30213.stgit@nfdev.cica.es>
 <20141226125133.16382.87197.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, alvaroneay@gmail.com
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56639 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbbAEL1g (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 06:27:36 -0500
Content-Disposition: inline
In-Reply-To: <20141226125133.16382.87197.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Dec 26, 2014 at 01:51:33PM +0100, Arturo Borrero Gonzalez wrote:
> Instead of printing directly the payload to stdout, let's parse it with
> libnftnl, so we make sure we fetch a ruleset that we actually understand.

Alvaro has been working on a new interface that provides a callback to
express incremental updates through xml/json.

He should be posting that soon I guess, it would be good if this
change is based on that.
