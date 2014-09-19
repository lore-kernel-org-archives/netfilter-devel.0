From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft] the -nnn switch
Date: Fri, 19 Sep 2014 13:25:06 +0200
Message-ID: <20140919112505.GA1158@acer.localdomain>
References: <CAOkSjBgOpbJmOXEX=a1kPXqDMs673ZTfB_Qg=q4V5L2JTsg77g@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:40928 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753558AbaISLZO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 19 Sep 2014 07:25:14 -0400
Content-Disposition: inline
In-Reply-To: <CAOkSjBgOpbJmOXEX=a1kPXqDMs673ZTfB_Qg=q4V5L2JTsg77g@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Sep 19, 2014 at 11:49:02AM +0200, Arturo Borrero Gonzalez wrote:
> Hi,
> 
> the -nnn switch in in nftables is IMO a bit annoying.
> We are bounded to use that switch in every serious usage of nft.
> 
> Let me remember the current behaviour:
> 
>  -n -> don't translate IP addresses to names.
>  -nn -> also, don't translate gids/uids to names.
>  -nnn -> also, don't translate port numbers to names.
> default -> translate all numbers to names.
> 
> I propose here that before nftables goes absolutely mainstream we
> change the behaviour to the opposite:
> 
> -n -> translate IP addresses to names.
> -nn -> translate gids/uids to names.
> -nnn -> translate port numbers to names.
> default -> show all numerically.
> 
> What do you think?

That seems quite counter intuitive. I'd say the default should be not
to cause any network traffic for a regular system (not using LDAP or
whatever), which would be -n. So I would be fine with -n being the
default and adding an option to also translate hostnames.
