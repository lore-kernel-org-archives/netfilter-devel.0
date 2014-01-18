From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] data_reg: fix verdict format approach
Date: Sat, 18 Jan 2014 21:54:32 +0100
Message-ID: <20140118205432.GD4840@localhost>
References: <20140118165454.23517.40740.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kaber@trash.net
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40930 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751393AbaARUyh (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 18 Jan 2014 15:54:37 -0500
Content-Disposition: inline
In-Reply-To: <20140118165454.23517.40740.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jan 18, 2014 at 05:56:45PM +0100, Arturo Borrero Gonzalez wrote:
> Patrick reports that the XML/JSON formats of the data_reg object
> are not accuarate.
> 
> This patch updates these formats, so they are now as follow:
> 
>  * <data_reg type=value> with raw data (this doesn't change).
>  * <data_reg type=verdict> with a concrete verdict (eg drop accept) and an
>   optional <chain>, with destination.

Applied this v2 instead, btw.
