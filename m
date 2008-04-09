From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [PATCH 3/8] [NETFILTER]: rename NF_ARP to NFPROTO_ARP and assign
 a non-clashing value
Date: Wed, 9 Apr 2008 15:17:14 +0200 (CEST)
Message-ID: <alpine.LNX.1.10.0804091514550.4411@fbirervta.pbzchgretzou.qr>
References: <5130e28c2130c57a9a07ae21c552fe7db519473c.1207668694.git.jengelh@computergmbh.de> <2a75525ff0d60f2e71df2c9c3d040d3a76451713.1207668694.git.jengelh@computergmbh.de> <47FCBC24.4020209@trash.net> <alpine.LNX.1.10.0804091508480.4411@fbirervta.pbzchgretzou.qr>
 <47FCC0D2.7060306@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:39655 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754072AbYDINRP (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 9 Apr 2008 09:17:15 -0400
In-Reply-To: <47FCC0D2.7060306@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Wednesday 2008-04-09 15:12, Patrick McHardy wrote:
>> > > +enum {
>> > > +	__NFPROTO_MIN = AF_MAX,
>> > > +	NFPROTO_ARP,
>> > > +	__NFPROTO_MAX,
>> > > +};
>> > > [...]
>> > > -	xt = kmalloc(sizeof(struct xt_af) * NPROTO, GFP_KERNEL);
>> > > +	xt = kmalloc(sizeof(struct xt_af) * __NFPROTO_MAX, GFP_KERNEL);
>> > Thats quite ugly. I'd also prefer to keep the size in
>> > the nf_hooks declaration and elsewhere.
>> >
>> > How about:
>> >
>> > enum {
>> >  __NFPROTO_MIN = AF_MAX - 1,   (AF_MAX is actually max + 1)
>> >  NFPROTO_ARP,
>> >  __NFPROTO_MAX
>> > };
>> > #define NFPROTO_MAX	(__NFPROTO_MAX - 1)
>> 
>> Then what's the point of defining __NFPROTO_MAX?
>
> Its so ugly that everyone adding new values will notice it
> and not add something after it :)
>
>> > The array declarations should then use NFPROTO_MAX + 1.
>> 
>> Why +1 if MAX is ARP?
>
> Because array indices start at zero.
>

It's all whacked up, srsly.

#define AF_RXRPC 33
#define AF_MAX   34

IMHO we should just:

enum {
	NFPROTO_FOO = AF_MAX,
	NFPROTO_BAR,
	NFPROTO_BAZ,
	NFPROTO_MAX,
};

and use NFPROTO_MAX in lieu of AF_MAX where due.
Putting that into place with ARP means:

enum {
	NFPROTO_ARP = AF_MAX,
	NFPROTO_MAX,
};

and use NFPROTO_MAX. No __NFPROTO_MIN, no __NFPROTO_MAX, and
less confusion overall. How about it? :)
