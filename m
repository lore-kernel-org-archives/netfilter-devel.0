From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/2] src: support for XML parsing
Date: Fri, 3 May 2013 18:24:19 +0200
Message-ID: <20130503162419.GB5129@localhost>
References: <20130429123607.26114.18073.stgit@nfdev.cica.es>
 <20130429123612.26114.46794.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34177 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933017Ab3ECQY0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 May 2013 12:24:26 -0400
Content-Disposition: inline
In-Reply-To: <20130429123612.26114.46794.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Apr 29, 2013 at 02:36:12PM +0200, Arturo Borrero wrote:
> This patch adds capabilities for parsing a XML table/chain/rule
> 
> Some points to note: * the XML data is case sensitive (so
> <chain>asd</chain> != <chain>ASD</chain> != <CHAIN>asd</CHAIN>) *
> all exported functions will receive a XML and return an object (aka
> table|chain|rule) * XML parsing is done with libmxml
> (http://minixml.org)
> 
> NOTE: expr/target and expr/match binary data are ignored.
> 
> Some code examples/test cases will be added to libnftables in a
> future patch.

Please, you have to change this to some --enable-xml-parser option via
hen ./configure, so it's not a hard dependency on libmxml.
