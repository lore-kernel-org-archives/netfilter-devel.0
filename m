From: Oliver <olipro@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Subject: Re: [PATCH 0/2 v2] cleanup and shrink ipset handling code.
Date: Tue, 03 Sep 2013 13:25:47 +0200
Message-ID: <3165887.LzvLJ47Yyo@gentoovm>
References: <1378206205-19591-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.uptheinter.net ([77.74.196.236]:32881 "EHLO
	mail.uptheinter.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759831Ab3ICL0E (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Sep 2013 07:26:04 -0400
Received: from localhost (localhost [127.0.0.1])
	by mail.uptheinter.net (Postfix) with ESMTP id 480C0A2DB4
	for <netfilter-devel@vger.kernel.org>; Tue,  3 Sep 2013 12:26:00 +0100 (BST)
Received: from mail.uptheinter.net ([127.0.0.1])
	by localhost (vps2.uptheinter.net [127.0.0.1]) (amavisd-new, port 10024)
	with LMTP id UxndheN5w3aj for <netfilter-devel@vger.kernel.org>;
	Tue,  3 Sep 2013 12:25:48 +0100 (BST)
In-Reply-To: <1378206205-19591-1-git-send-email-oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

So, I should have marked this as v3, I'm losing track of how much junk I've 
sent out already it seems, sorry folks. And I forgot to update the commit 
messages to reflect what I actually did... there's no preprocessor macro 
involved any more, and it's just a single switch statement rather than two.

If anyone wants a re-roll, just shout.

Thanks, Oliver

On Tuesday 03 September 2013 13:03:23 Oliver wrote:
> From: Oliver Smith <oliver@8.c.9.b.0.7.4.0.1.0.0.2.ip6.arpa>
> 
> Following on from my previous patch, I noticed that the existing way
> of managing the extensions could actually be trivially reworked by
> simply checking each flag bit in series and setting up the size and
> offsets incrementally. This makes adding new extensions as simple as
> throwing a new case into the switch, no set file changes needed. It
> also avoids having to do any unpleasant upheaveal of timeout.
> 
> This patch is intended to apply directly against the current HEAD of
> master in the ipset repo.
> 
> One caveat to note is that since we now define each extension
> independently, it is important to ensure a proper alignment value so
> that each subsequent struct ends up on a "nice" boundary in memory.
> Since both timeout and counter should align on their own nicely, I
> didn't bother adding alignment statements to them. Anyone writing a
> new extension should ensure they're a good codizen and align appropriately.
> 
> On that note, there is the option of simply aligning everything to the GCC
> value __BIGGEST_ALIGNMENT__, on my 64-bit box that comes out at 16 bytes,
> perhaps that's overkill - although there are instructions that can do a 16
> byte load. Perhaps I'm just going overboard though... in6_addr doesn't even
> align to 64 bits, so maybe nobody cares but me. <breaks out the violin>
> 
> Cheers!
> 
> Oliver Smith (2):
>   netfilter: ipset: rework hash ext. handling to be more manageable.
>   netfilter: ipset: rework bitmap ext. handling to be more manageable.
> 
>  kernel/include/linux/netfilter/ipset/ip_set.h      |   4 +
>  kernel/include/uapi/linux/netfilter/ipset/ip_set.h |   8 +-
>  kernel/net/netfilter/ipset/ip_set_bitmap_gen.h     |  34 +++++++
>  kernel/net/netfilter/ipset/ip_set_bitmap_ip.c      |  87 ++----------------
> kernel/net/netfilter/ipset/ip_set_bitmap_ipmac.c   |  96
> ++----------------- kernel/net/netfilter/ipset/ip_set_bitmap_port.c    | 
> 76 +-------------- kernel/net/netfilter/ipset/ip_set_hash_gen.h       | 102
> ++++++--------------- kernel/net/netfilter/ipset/ip_set_hash_ip.c        | 
> 36 +------- kernel/net/netfilter/ipset/ip_set_hash_ipport.c    |  54
> +---------- kernel/net/netfilter/ipset/ip_set_hash_ipportip.c  |  58
> +----------- kernel/net/netfilter/ipset/ip_set_hash_ipportnet.c |  66
> +------------ kernel/net/netfilter/ipset/ip_set_hash_net.c       |  54
> +---------- kernel/net/netfilter/ipset/ip_set_hash_netiface.c  |  67
> +------------- kernel/net/netfilter/ipset/ip_set_hash_netport.c   |  60
> +----------- 14 files changed, 106 insertions(+), 696 deletions(-)

What are you doing down here? I don't usually top post, but since it's in 
reply to my own...
