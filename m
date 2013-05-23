From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v4] src: support for XML parsing
Date: Thu, 23 May 2013 13:21:19 +0200
Message-ID: <20130523112119.GA22678@localhost>
References: <20130514145049.6008.84412.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56604 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757985Ab3EWLV3 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 May 2013 07:21:29 -0400
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
> 
> NOTE: expr/target and expr/match binary data are ignored.

I fixed compilation without --with-xml-parsing, that case was probably
untested.

Finally applied with minor glitches. If you have follow up patches,
please make sure you rebase your tree upon current.

Thanks Arturo.
