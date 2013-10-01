From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH 2/3] table: json: fix json style
Date: Tue, 1 Oct 2013 11:43:58 +0200
Message-ID: <20131001094358.GA7573@localhost>
References: <20130930150551.32124.23680.stgit@nfdev.cica.es>
 <20130930150557.32124.88117.stgit@nfdev.cica.es>
 <20130930110644.07aa64c1@nehalam.linuxnetplumber.net>
 <20130930183401.GA972@localhost>
 <CAOkSjBgtDpNAJ0zHbpJ417+rdnse0gstAHqgEQqiNo9BSRv+Jw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Alvaro Neira Ayuso <alvaroneay@gmail.com>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:30557 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752482Ab3JAJoE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 1 Oct 2013 05:44:04 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBgtDpNAJ0zHbpJ417+rdnse0gstAHqgEQqiNo9BSRv+Jw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Sep 30, 2013 at 11:55:25PM +0200, Arturo Borrero Gonzalez wrote:
> On 30 September 2013 20:34, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Mon, Sep 30, 2013 at 11:06:44AM -0700, Stephen Hemminger wrote:
> >> On Mon, 30 Sep 2013 17:05:57 +0200
> >> Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com> wrote:
> >>
> >> > Be consistent in JSON style.
> >> >
> >> > Signed-off-by: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> >>
> >> All the effort to format and add whitespace in JSON is not that important
> >> since it is intended to be parsed by something, and parsers ignore it.
> >> Many applications just use as little whitespace as possible to reduce size
> >> of output!
> >
> > Thanks Stephen, we'll stick to using as little whitespace as possible.
> >
> > Moreover, there are tools and functions (included in libjansson) to
> > make this human friendly, in case anyone needs it.
> 
> I also don't care so much about the format, actually (white spaces or
> not..). I just tried to give some consistency.
> 
> { \"rule\":
> { \"chain\":
> { \"set\":
> {\"table\" :

For consistency, please send me a patch to remove the spaces. Thanks!
