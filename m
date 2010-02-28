From: Pierre Chifflier <chifflier@edenwall.com>
Subject: Re: [PATCH 1/2] Add new input plugin UNIXSOCK
Date: Sun, 28 Feb 2010 19:05:05 +0100
Message-ID: <20100228180505.GD16135@piche.inl.fr>
References: <1267217680-22677-1-git-send-email-chifflier@edenwall.com>
 <1267217680-22677-2-git-send-email-chifflier@edenwall.com>
 <4B892440.7030002@netfilter.org>
 <20100228140655.GC16135@piche.inl.fr>
 <4B8A99B6.5080708@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Pierre Chifflier <chifflier@edenwall.com>,
	netfilter-devel@vger.kernel.org, eleblond@edenwall.com
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:55595 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754394Ab0B1SFP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 28 Feb 2010 13:05:15 -0500
Content-Disposition: inline
In-Reply-To: <4B8A99B6.5080708@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 28, 2010 at 05:28:38PM +0100, Pablo Neira Ayuso wrote:
> >>> +struct ulogd_unixsock_option_t  {
> >>> +	uint16_t option_id;
> >>> +	uint16_t option_length;
> >>> +	char     option_value[0];
> >>> +} __attribute__((packed));
> >>> +
> >>> +#define ALIGN_SIZE 8
> >> Minor question: why align this to 64 bits?
> > 
> > I originally used an alignment to 32 bits, but Jan noticed it would
> > break if using options/values on 64 bits (and a test confirmed that). I
> > took 64 bits as the biggest allowed value for integers.
> 
> I would need to look into this in more detail, not sure where the
> problem is. I think that you can use something like `struct nlattr' (see
> include/linux/netlink.h) and then nla_put() to add attributes in the TLV
> format (see lib/nlattr.c). Those are align-safe. I'm using something
> similar for conntrackd for the synchronization messages (src/build.c and
> src/parse.c).
> 

Yes, this is very similar though NLA_ALIGNTO is set to 4 which will
cause problems with 64 bits integers.
The other way to solve this would be to read integers byte per byte,
like in [1], but I found this not very elegant (and is likely to be slow
compared to aligned access).

Or do you have any preferred solution ? Maybe using nlattr + one special
function for dealing with 64 bits variables ?

Pierre

[1] https://dev.prelude-technologies.com/projects/libprelude/repository/revisions/master/entry/src/include/prelude-extract.h
