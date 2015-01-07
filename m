From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ebtables-compat PATCH v2] ebtables-compat: incluyde
 /etc/ethertypes in tarball
Date: Wed, 7 Jan 2015 18:18:50 +0100
Message-ID: <20150107171850.GA10168@salvia>
References: <20150107162111.30498.33295.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>, f@salvia
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:40380 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754440AbbAGRQE (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 Jan 2015 12:16:04 -0500
Content-Disposition: inline
In-Reply-To: <20150107162111.30498.33295.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 07, 2015 at 05:22:01PM +0100, Arturo Borrero Gonzalez wrote:
> The /etc/ethertypes file was originally distributed by the ebtables tarball.
> So, let's include the file also in ebtables-compat, so users can keep using
> protocol names instead of the hex code.

Applied to the ebtables-compat-experimental6 branch, thanks.
