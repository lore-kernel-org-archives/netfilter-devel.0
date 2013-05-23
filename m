From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] examples: XML parsing examples
Date: Thu, 23 May 2013 13:22:11 +0200
Message-ID: <20130523112211.GA22689@localhost>
References: <20130522103325.904.74543.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56807 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758022Ab3EWLWP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 May 2013 07:22:15 -0400
Content-Disposition: inline
In-Reply-To: <20130522103325.904.74543.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, May 22, 2013 at 12:33:25PM +0200, Arturo Borrero wrote:
> Some code snipplets to add tables/chain/rules using the XML representation.
> 
> The examples contains:
>  * A binary to parse/add the object using libnftables.
>  * A shellscript to easily call that binary, doing some tests.
>  * table/chain/rule sample XML file.

Applied with minor comestic cleanups, thanks Arturo.
