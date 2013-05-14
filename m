From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v4] src: support for XML parsing
Date: Wed, 15 May 2013 00:35:32 +0200
Message-ID: <20130514223531.GA10121@localhost>
References: <20130514145049.6008.84412.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55346 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758091Ab3ENWfg (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 14 May 2013 18:35:36 -0400
Content-Disposition: inline
In-Reply-To: <20130514145049.6008.84412.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 14, 2013 at 04:51:16PM +0200, Arturo Borrero wrote:
> This patch adds capabilities for parsing a XML table/chain/rule
> 
> Some points to note:
> 	* the XML data is case sensitive (so <chain>asd</chain> != <chain>ASD</chain> != <CHAIN>asd</CHAIN>)
> 	* all exported functions will receive a XML and return an object (aka table|chain|rule)
> 	* To compile the lib with XML parsing support, run './configure --with-xml-parsing'
> 	* XML parsing is done with libmxml (http://minixml.org). XML parsing depends on this external lib.

This looks good. Thanks for the patch.

> NOTE: expr/target and expr/match binary data are ignored.
>
> Some code examples/test cases will be added to libnftables in a future patch.

I'm looking forward to having those example files, I would like to
use them to test this before applying it to master.
