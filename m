From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] xml: expr: fix public interface for parsing
 XML
Date: Fri, 26 Jul 2013 16:19:34 +0200
Message-ID: <20130726141934.GA13991@localhost>
References: <20130726120031.4081.51723.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42157 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756837Ab3GZOTj (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Jul 2013 10:19:39 -0400
Content-Disposition: inline
In-Reply-To: <20130726120031.4081.51723.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Arturo,

On Fri, Jul 26, 2013 at 02:00:31PM +0200, Arturo Borrero Gonzalez wrote:
> This patch adds a public interface for parsing expr XML.
> Before this patch, that operation was not possible.

rule parse already parses expressions.

Do you need this? If so, please specify the usage. Thanks.
