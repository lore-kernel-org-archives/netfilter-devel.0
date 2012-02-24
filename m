From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ulogd2 / DBI / table name
Date: Fri, 24 Feb 2012 18:59:30 +0100
Message-ID: <20120224175930.GA11837@1984>
References: <20120212225627.GH3216@prithivi.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harald Welte <laforge@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:44609 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932095Ab2BXR7u (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Feb 2012 12:59:50 -0500
Content-Disposition: inline
In-Reply-To: <20120212225627.GH3216@prithivi.gnumonks.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 12, 2012 at 11:56:27PM +0100, Harald Welte wrote:
> Hi!
> 
> I've tried to use the DBI plugin of ulogd2 for NFCT based accounting,
> and despite using table="conntrack", it always insisted in using the
> table "ulog" for deriving the keys/columns to be stored.
> 
> I've hacked up a quick fix, and it seems to work as expected (though no
> proper null temrmination after strncpy).
> 
> As I've been absent from ulogd and netfilter hacking for some time, I
> tohught I'd post it here rather than pushing something to the git
> repo...

Applied, thanks Harald!
