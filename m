From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/3] parsing: add interface to parse from file
Date: Thu, 9 Jan 2014 17:58:04 +0100
Message-ID: <20140109165804.GB15460@localhost>
References: <20140109111906.32565.65222.stgit@nfdev.cica.es>
 <20140109111912.32565.7315.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50332 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751705AbaAIQ6I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 9 Jan 2014 11:58:08 -0500
Content-Disposition: inline
In-Reply-To: <20140109111912.32565.7315.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 09, 2014 at 12:19:12PM +0100, Arturo Borrero Gonzalez wrote:
> This patch adds API interfaces to parse nft objects from a given stream.
> I found this useful in `nft', where I'm trying to parse XML/JSON from a file.
> 
> In addition to the API functions, a new builder is added to handle a file.

Also applied, thanks.
