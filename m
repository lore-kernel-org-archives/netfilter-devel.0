From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC PATCH] netfilter: nf_tables: add new write expression
Date: Sun, 16 Feb 2014 10:36:22 +0000
Message-ID: <20140216103621.GA28646@macbook.localnet>
References: <1392470242-4515-1-git-send-email-nikolay@redhat.com>
 <61379b1e-8f7e-4596-badb-fd41e1657f83@email.android.com>
 <52FF6D3A.6020202@redhat.com>
 <20140216100953.GA4952@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Nikolay Aleksandrov <nikolay@redhat.com>,
	netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:38694 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751040AbaBPKg0 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 16 Feb 2014 05:36:26 -0500
Content-Disposition: inline
In-Reply-To: <20140216100953.GA4952@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Feb 16, 2014 at 11:09:53AM +0100, Pablo Neira Ayuso wrote:
> On Sat, Feb 15, 2014 at 02:35:54PM +0100, Nikolay Aleksandrov wrote:
> > On 02/15/2014 02:30 PM, Patrick McHardy wrote:
> > > On 15. Februar 2014 13:17:22 GMT+00:00, Nikolay Aleksandrov <nikolay@redhat.com> wrote:
> > >> The new "write" expression can be used to manipulate packet data.
> > >> The parameters that it has are source register (source for the bytes
> > >> which are to be written), offset in the packet and length to write.
> > >> It uses a select_ops method to choose between fast ops in the cases
> > >> length is 1,2 or 4 bytes and slow ops (i.e. using memcpy) in other
> > >> cases.
> > >>
> > >> Signed-off-by: Nikolay Aleksandrov <nikolay@redhat.com>
> > >> ---
> > >> I needed a way (other than passing the packets to user-space) to alter
> > >> the ToS field via nftables, so I decided to make it a bit more general.
> > >> I
> > >> use it with the immediate expression to load the new ToS and then write
> > >> it.
> > >> If you find this useful I can post the libnftnl patch as well.
> > >> Right now as you can see it continues even if the "write" wasn't
> > >> successful
> > >> which should be probably changed to NFT_BREAK for that case.
> > > 
> > > Yes.
> > > 
> > >> This patch applies to Dave's net-next tree.
> > > 
> > > I think this is a useful addition. However I prefer to put thus
> > > into the payload expression and select the proper ops based on the
> > > presence of sreg/dreg.
> > > 
> > Okay, makes sense. I'll re-write it in such form taking into consideration
> > the other comments and will re-post after some testing.
> 
> You can use this patch as reference to make it:
> 
> commit e035b77ac7be430a5fef8c9c23f60b6b50ec81c5
> Author: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
> Date:   Thu Dec 26 16:38:01 2013 +0100
> 
>     netfilter: nf_tables: nft_meta module get/set ops
> 
> That patch is similar to what you propose, but it sets the meta fields
> of a packet.

Actually I'd propose two different init functions, that's just not pretty.
