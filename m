From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nf-next/nf_tables8] Unable to compile kernel
Date: Mon, 18 Feb 2013 18:28:43 +0100
Message-ID: <20130218172843.GA29465@localhost>
References: <CAOkSjBh78knOWQLmFnz+XyW4umVVnVVkWs9VeYPJdzhxg3T_fg@mail.gmail.com>
 <20130218165952.GA19904@localhost>
 <CAOkSjBjHQhgM0SB7cnXKpZ03nNvdK8NCVyUf+Po-jopOViAQvw@mail.gmail.com>
 <CAOkSjBhL6hgA8fHxE+W3yTLnXMfJja24JjLJSvbbfg2wC0rt8w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from slan-550-85.anhosting.com ([174.127.110.175]:51285 "EHLO
	slan-550-85.anhosting.com" rhost-flags-OK-FAIL-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756543Ab3BRR2t (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:28:49 -0500
Content-Disposition: inline
In-Reply-To: <CAOkSjBhL6hgA8fHxE+W3yTLnXMfJja24JjLJSvbbfg2wC0rt8w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 18, 2013 at 06:16:21PM +0100, Arturo Borrero Gonzalez wrote:
> 2013/2/18 Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>:
> > I'm to use 'nftables' branch. Is this correct?
> >
> > Regards.
> >
> 
> Also, i'm unable to clone the repo:
> 
> ~$ git clone git://1984.lsi.us.es/nftables
> Cloning into 'nftables'...
> fatal: The remote end hung up unexpectedly
> 
> Any idea?

$ git clone git://1984.lsi.us.es/nftables.git
Cloning into 'nftables'...
Remote: Counting objects: 75738 

Should be working now.
