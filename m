From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] data_reg: xml: delete unreachable code in
 _veredict_xml_parse()
Date: Sat, 8 Jun 2013 19:25:36 +0200
Message-ID: <20130608172536.GA4244@localhost>
References: <20130608140233.2361.71553.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46357 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751276Ab3FHRZl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Jun 2013 13:25:41 -0400
Content-Disposition: inline
In-Reply-To: <20130608140233.2361.71553.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jun 08, 2013 at 04:02:33PM +0200, Arturo Borrero wrote:
> This code was unreachable.
> 
> There was a similar commit fixing a similar code which didn't fix this (414ac29).

Applied.
