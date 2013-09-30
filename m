From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/3] table: json: fix json style
Date: Mon, 30 Sep 2013 20:34:01 +0200
Message-ID: <20130930183401.GA972@localhost>
References: <20130930150551.32124.23680.stgit@nfdev.cica.es>
 <20130930150557.32124.88117.stgit@nfdev.cica.es>
 <20130930110644.07aa64c1@nehalam.linuxnetplumber.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	netfilter-devel@vger.kernel.org
To: Stephen Hemminger <stephen@networkplumber.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50982 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755300Ab3I3SeH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 30 Sep 2013 14:34:07 -0400
Content-Disposition: inline
In-Reply-To: <20130930110644.07aa64c1@nehalam.linuxnetplumber.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 30, 2013 at 11:06:44AM -0700, Stephen Hemminger wrote:
> On Mon, 30 Sep 2013 17:05:57 +0200
> Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> 
> > Be consistent in JSON style.
> > 
> > Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> 
> All the effort to format and add whitespace in JSON is not that important
> since it is intended to be parsed by something, and parsers ignore it.
> Many applications just use as little whitespace as possible to reduce size
> of output!

Thanks Stephen, we'll stick to using as little whitespace as possible.

Moreover, there are tools and functions (included in libjansson) to
make this human friendly, in case anyone needs it.
