From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH netfilter: nft] add connmark module
Date: Mon, 6 Jan 2014 14:09:19 +0100
Message-ID: <20140106130919.GA8238@localhost>
References: <1389011352-11449-1-git-send-email-kristian.evensen@gmail.com>
 <20140106124227.GA7743@localhost>
 <CAKfDRXisUL5yBbU3bZfo52GxU96BamC75vPWsFvOYg7u8Jhs1w@mail.gmail.com>
 <20140106124944.GA7830@localhost>
 <CAKfDRXi1UYX120_ndw_hCNVyB2X+TEAOiUTamG3ZNw-vBruv9A@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57209 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751549AbaAFNJ0 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:09:26 -0500
Content-Disposition: inline
In-Reply-To: <CAKfDRXi1UYX120_ndw_hCNVyB2X+TEAOiUTamG3ZNw-vBruv9A@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 02:02:55PM +0100, Kristian Evensen wrote:
> Yes, that sounds like a better solution. I will get started on adding
> this functionality. One question though, how should we deal with the
> masks? Based on my limited understanding, it is only possible to store
> one value per meta key.

Please, check the bitwise expression (net/netfilter/nft_bitwise.c), it
provides an instruction to perform bitwise operations.

> Also, what would be the preferred syntax? When looking at the existing
> meta set/get, I suggest something like the following:
> 
> ... meta connmark set X
> ... meta connmark-restore
> ... meta connmark-save.

Unless someone else come with a better syntax proposal, that's fine
with me.

P.S: Please, don't top post:
http://www.netfilter.org/mailinglists.html#list-rules
