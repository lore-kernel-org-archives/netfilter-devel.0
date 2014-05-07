From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] data_reg: fix bad buffer size bounds
Date: Wed, 7 May 2014 15:39:32 +0200
Message-ID: <20140507133932.GB4890@localhost>
References: <20140506171946.4163.82349.stgit@nfdev.cica.es>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:32930 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933138AbaEGNjl (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 7 May 2014 09:39:41 -0400
Content-Disposition: inline
In-Reply-To: <20140506171946.4163.82349.stgit@nfdev.cica.es>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 06, 2014 at 07:19:46PM +0200, Arturo Borrero Gonzalez wrote:
> These calls need to use the new buffer size, instead of the
> size that the buffer originally had.
> 
> Bugs introduced by myself at dec68741 [data_reg: fix verdict format approach].

Applied, thanks Arturo.
