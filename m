From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH netfilter: nft] add connmark module
Date: Mon, 6 Jan 2014 13:49:44 +0100
Message-ID: <20140106124944.GA7830@localhost>
References: <1389011352-11449-1-git-send-email-kristian.evensen@gmail.com>
 <20140106124227.GA7743@localhost>
 <CAKfDRXisUL5yBbU3bZfo52GxU96BamC75vPWsFvOYg7u8Jhs1w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:55375 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816AbaAFMtt (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 07:49:49 -0500
Content-Disposition: inline
In-Reply-To: <CAKfDRXisUL5yBbU3bZfo52GxU96BamC75vPWsFvOYg7u8Jhs1w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 01:46:08PM +0100, Kristian Evensen wrote:
> Hi,
> 
> Thanks. I noticed the addition of the get/set operation while working
> on the patch and was unsure about how to deal with setting the
> connmark, but I decided to add it for completeness sake. Perhaps a
> better idea would be to remove set from the module and only keep
> save/restore? It would simplify the code as well.

I think one single NFT_META_CONNMARK with the get/set variants should
be enough to implement the save, restore and set operations that
xt_connmark provides.

* restore:
        reg1 = get(NFT_META_CONNMARK)
        set(NFT_META_MARK, reg1)

* save:
        reg1 = get(NFT_META_MARK)
        set(NFT_META_CONNMARK, reg1)

* set:
        reg1 = immediate(value)
        set(NFT_META_CONNMARK, reg1)
