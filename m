From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] parsing: add interface to parse from file
Date: Mon, 6 Jan 2014 13:25:04 +0100
Message-ID: <20140106122504.GA7639@localhost>
References: <20140103123145.27058.77216.stgit@nfdev.cica.es>
 <20140104011333.GA5250@localhost>
 <CAOkSjBgJDk_06xvJjX+X4SaThuGZk5NRNGhxkOpATAyUKXrRoA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Alvaro Neira <alvaroneay@gmail.com>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:53661 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750855AbaAFMZV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:25:21 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBgJDk_06xvJjX+X4SaThuGZk5NRNGhxkOpATAyUKXrRoA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 01:06:04PM +0100, Arturo Borrero Gonzalez wrote:
[...]
> > Alvaro's patch is also changing the internal.h file. You need to
> > coordinate since you're working on the parsing infrastructure at the
> > same time to avoid clashing on this, otherwise the patch coming later
> > won't apply and one of you will have to rework it.
> 
> I think Alvaro's patch should come first, as he was already working on
> this previous to my patch.
> 
> I will wait until alvaro's one is applied to make the refresh.

I did apply it already, thanks Arturo.
