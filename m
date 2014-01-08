From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 3/6] internal: rework parsing symbol logic
Date: Wed, 8 Jan 2014 13:25:28 +0100
Message-ID: <20140108122528.GA25406@localhost>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
 <20140107114726.12841.59406.stgit@nfdev.cica.es>
 <20140107231813.GC16894@localhost>
 <CAOkSjBibj-66qf2mr=26d1GPfASJFjb+9Bbyv2LOsi3rUkuyYw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60041 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755610AbaAHMZd (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:25:33 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBibj-66qf2mr=26d1GPfASJFjb+9Bbyv2LOsi3rUkuyYw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Jan 08, 2014 at 01:20:51PM +0100, Arturo Borrero Gonzalez wrote:
> On 8 January 2014 00:18, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > We don't save any ifdef.
> 
> Well, we need at least one ifdef per format. I don't see how we can
> get rid of them.
> 
> This patch just condensates the logic to one single point, also adding
> the void definition, which is good for other patches in the series.

OK, then you have to include in the description that it simplifies
follow-up patches and in what way.

But I also rised some concerns on the follow-up patches that you have
to address.
