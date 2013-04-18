From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftables PATCH v2] Basic support for printing nft_data_reg
 in XML format.
Date: Fri, 19 Apr 2013 01:24:10 +0200
Message-ID: <20130418232410.GA16815@localhost>
References: <20130408083022.9188.50453.stgit@nfdev.cica.es>
 <20130409194255.GA5544@localhost>
 <CAOkSjBg9WD5E_ePjdat-E8vb1cXAMTafaF-FyW4-e49q7Uo7Rw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50822 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936608Ab3DRXYP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 18 Apr 2013 19:24:15 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBg9WD5E_ePjdat-E8vb1cXAMTafaF-FyW4-e49q7Uo7Rw@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 09, 2013 at 10:26:48PM +0200, Arturo Borrero Gonzalez wrote:
> 2013/4/9 Pablo Neira Ayuso <pablo@netfilter.org>:
> >
> > Cannot use "data" instead of immediate data? This is nested in
> > <immediate>...</immediate>, it seems redundant to me.
> 
> Understood. And I will fix it.
> 
> But let me explain why I did it:
> 
> for example, cmp is using <cmpdata>
> <cmpdata> has <data_reg></data_reg> which can also be redundant.
> 
> But all around the XML printing (including sets, an incoming patch)
> i've been nesting the data_reg into another XML node, so you could
> easily see (also the XML parser) the difference between (for example.
> in set) nft_set_elem->key and nft_set_elem->data.
> As I needed to nest in nft_set_elem I decided to follow a constant
> line and do nest all data_reg.

Fair enough. I have applied this patch.
