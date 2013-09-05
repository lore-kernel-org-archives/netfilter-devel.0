From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH] set: xml: fix key_type parsing
Date: Thu, 5 Sep 2013 11:08:13 +0200
Message-ID: <20130905090813.GA5396@localhost>
References: <20130904160324.19268.79096.stgit@nfdev.cica.es>
 <20130905085340.GA4317@localhost>
 <CAOkSjBhSTxGXbMA3Yy2mt2JDCgc0eRDaRYjygRUNACrB4BKYZg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46644 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757674Ab3IEJIT (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Sep 2013 05:08:19 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBhSTxGXbMA3Yy2mt2JDCgc0eRDaRYjygRUNACrB4BKYZg@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Sep 05, 2013 at 10:58:02AM +0200, Arturo Borrero Gonzalez wrote:
> On 5 September 2013 10:53, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> > On Wed, Sep 04, 2013 at 06:03:25PM +0200, Arturo Borrero Gonzalez wrote:
> >> Bug introduced by myself at 44928cd5 [set: add XML parsing]
> >
> > Applied.
> >
> > Please, investigate why the json/xml test infrastructure did not catch
> > up this. Thanks.
> 
> The current testfiles for set uses the same value both in key_type and key_len.

I expected something like this.

> In fact, I discovered this bug using nft-parsing-test, but with
> others, additional files.

I see, I think that including such a test to master would be good.

Regards.
