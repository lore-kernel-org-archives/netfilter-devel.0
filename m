From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] tests: add table 'use' attr to testfiles
Date: Sat, 4 Jan 2014 00:16:11 +0100
Message-ID: <20140103231611.GA12168@localhost>
References: <20140102104653.9536.42033.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39078 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753492AbaACXQR (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 3 Jan 2014 18:16:17 -0500
Content-Disposition: inline
In-Reply-To: <20140102104653.9536.42033.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 02, 2014 at 11:49:06AM +0100, Arturo Borrero Gonzalez wrote:
> Parsing tests were failing because a missing 'use' attribute in tables.
> 
> validating xmlfiles/02-table.xml: FAILED
> from file:     0</flags></table>
> f
> from snprintf: 0</flags><use>0</use
>                          ^
> [...]
> 
> validating jsonfiles/64-ruleset.json: FAILED
> from file:     ,"flags":0}},{"chain
> from snprintf: ,"flags":0,"use":0}}
>                          ^

Applied, thanks.
