From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftables v2] Add support for ct set
Date: Fri, 10 Jan 2014 12:30:43 +0100
Message-ID: <20140110113043.GA6372@localhost>
References: <1389170211-7024-1-git-send-email-kristian.evensen@gmail.com>
 <20140110005015.GA18032@localhost>
 <CAKfDRXg_Ks3uPY6T9vr0pa_OgMT7ZrxdnGPTqxOvfFjoznMUeA@mail.gmail.com>
 <20140110103758.GA4732@localhost>
 <CAOkSjBjFnfRhQ+3seVLx_i-JrzdQwcefD_U_COByX=EidOoXBw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Kristian Evensen <kristian.evensen@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45993 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751152AbaAJLbH (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jan 2014 06:31:07 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBjFnfRhQ+3seVLx_i-JrzdQwcefD_U_COByX=EidOoXBw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Jan 10, 2014 at 12:06:29PM +0100, Arturo Borrero Gonzalez wrote:
> On 10 January 2014 11:37, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> >
> > That's inconsistent and needs to be fixed. My suggestion is to fix it
> > by using u32 for registers. Thanks.
> 
> cmp [0] also uses uint8_t for a register.
> 
> Also, others [1] use 'enum nft_registers'.
> 
> Should I patch all and switch to enum nft_registers?

Yes please, go ahead review that. Thanks.
