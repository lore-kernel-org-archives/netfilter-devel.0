From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] utils: fix buffer reallocation of nft_fprinft()
Date: Tue, 13 May 2014 14:49:10 +0200
Message-ID: <20140513124910.GA3784@localhost>
References: <20140509164547.7057.94412.stgit@nfdev.cica.es>
 <20140512155457.GB12698@localhost>
 <CAOkSjBjpMa4uipdXx8wzgLEDf8PcH_nXXZUNRJrjBkzSJQD-MQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37260 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932613AbaEMNDp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 13 May 2014 09:03:45 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBjpMa4uipdXx8wzgLEDf8PcH_nXXZUNRJrjBkzSJQD-MQ@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 13, 2014 at 11:11:24AM +0200, Arturo Borrero Gonzalez wrote:
> On 12 May 2014 17:54, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > You can use malloc instead. Just make sure that the string is always
> > nul-terminated before printing, something like:
> >
> >                 bufsiz = ret + 1;
> >                 buf = malloc(1, bufsiz);
> >                 if (buf == NULL)
> >                         return -1;
> >
> >                 ret = snprintf(...
> >                 if (ret < 0)
> >                         ...
> >         }
> >
> >         buf[ret] = '\0';
> >         ... = fprintf(...
> >
> 
> From my man pages, I understand that snprintf() null-terminate the
> string. This seems a bit redundant.

If the amount of written bytes is smaller than the buffer size,
snprintf always nul-terminate it. But if the amount of bytes returned
equals the buffer size, then you have to explicitly nul-terminate the
string.

> I think it's safe to don't include calloc() neither buf[ret] = '\0'.

Right, if you use a buffer size of ret + 1, then you can guarantee
that snprintf always have room to append the nul-termination, as the
returned value will be ret at maximum.

> I'm resending this patch with this assumption and your other request.

OK, thanks.
