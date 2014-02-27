From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] src: check if netlink parsing fails
Date: Thu, 27 Feb 2014 10:35:50 +0100
Message-ID: <20140227093550.GB4457@localhost>
References: <20140226181326.26149.52163.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59034 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750781AbaB0Jf4 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 27 Feb 2014 04:35:56 -0500
Content-Disposition: inline
In-Reply-To: <20140226181326.26149.52163.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 26, 2014 at 07:13:26PM +0100, Arturo Borrero Gonzalez wrote:
> We have to check if mnl_attr_parse() returns an error, which means that it
> failed to validate and retrieve the attributes.

Applied with minor glitches, please see pushed patch to master.

Thanks a lot Arturo.
