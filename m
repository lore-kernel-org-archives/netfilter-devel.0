From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH netfilter: nft] add connmark module
Date: Mon, 6 Jan 2014 14:02:55 +0100
Message-ID: <CAKfDRXi1UYX120_ndw_hCNVyB2X+TEAOiUTamG3ZNw-vBruv9A@mail.gmail.com>
References: <1389011352-11449-1-git-send-email-kristian.evensen@gmail.com>
	<20140106124227.GA7743@localhost>
	<CAKfDRXisUL5yBbU3bZfo52GxU96BamC75vPWsFvOYg7u8Jhs1w@mail.gmail.com>
	<20140106124944.GA7830@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f177.google.com ([209.85.192.177]:59689 "EHLO
	mail-pd0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750950AbaAFNCz (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 08:02:55 -0500
Received: by mail-pd0-f177.google.com with SMTP id q10so17880914pdj.8
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 05:02:55 -0800 (PST)
In-Reply-To: <20140106124944.GA7830@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Yes, that sounds like a better solution. I will get started on adding
this functionality. One question though, how should we deal with the
masks? Based on my limited understanding, it is only possible to store
one value per meta key.

Also, what would be the preferred syntax? When looking at the existing
meta set/get, I suggest something like the following:

... meta connmark set X
... meta connmark-restore
... meta connmark-save.

-Kristian

On Mon, Jan 6, 2014 at 1:49 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> On Mon, Jan 06, 2014 at 01:46:08PM +0100, Kristian Evensen wrote:
>> Hi,
>>
>> Thanks. I noticed the addition of the get/set operation while working
>> on the patch and was unsure about how to deal with setting the
>> connmark, but I decided to add it for completeness sake. Perhaps a
>> better idea would be to remove set from the module and only keep
>> save/restore? It would simplify the code as well.
>
> I think one single NFT_META_CONNMARK with the get/set variants should
> be enough to implement the save, restore and set operations that
> xt_connmark provides.
>
> * restore:
>         reg1 = get(NFT_META_CONNMARK)
>         set(NFT_META_MARK, reg1)
>
> * save:
>         reg1 = get(NFT_META_MARK)
>         set(NFT_META_CONNMARK, reg1)
>
> * set:
>         reg1 = immediate(value)
>         set(NFT_META_CONNMARK, reg1)
