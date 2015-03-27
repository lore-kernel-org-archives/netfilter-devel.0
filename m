From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft PATCH 2/3] src: add xt compat support
Date: Fri, 27 Mar 2015 12:31:19 +0000
Message-ID: <20150327123119.GA24870@acer.localdomain>
References: <20150325191556.13491.88761.stgit@nfdev2.cica.es>
 <20150325191602.13491.63370.stgit@nfdev2.cica.es>
 <20150325194441.GA26737@salvia>
 <CAOkSjBivwzs8X+y1PRqG8-hg4b-0QQ_NXfJ38YoT9V05vt7Bag@mail.gmail.com>
 <20150327123139.GA10614@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:34779 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752444AbbC0MbZ (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 27 Mar 2015 08:31:25 -0400
Content-Disposition: inline
In-Reply-To: <20150327123139.GA10614@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 27.03, Pablo Neira Ayuso wrote:
> On Fri, Mar 27, 2015 at 01:00:37PM +0100, Arturo Borrero Gonzalez wrote:
> > On 25 March 2015 at 20:44, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > 
> > % sudo nft add rule bridge filter FORWARD xt match 802_3 [--802_3-sap 0x01  ]
> > <cmdline>:1:41-43: Error: syntax error, unexpected number
> > add rule bridge filter FORWARD xt match 802_3 [--802_3-sap 0x01 ]
> >                                         ^^^
> > 
> > I have to admit I don't know where to look. Do you have any hint?
> 
> I know see the problem, the scanner doesn't consider that a string can
> start by a number, we have a similar problem with the expiration time.
> Well, I would keep it there until we find a better solution. Please,
> check if we have more extensions with this pattern.

For this specifc case what might work is add a token

"match [^ ]+"

and return XT_MATCH as token type and the name as value. This will of
course not allow to use "match" for anything else, including identifiers.
