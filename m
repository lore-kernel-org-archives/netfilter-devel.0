From: Kristian Evensen <kristian.evensen@gmail.com>
Subject: Re: [PATCH netfilter: nft] add connmark module
Date: Mon, 6 Jan 2014 16:19:40 +0100
Message-ID: <CAKfDRXiAoruPm8H9moqyfZ4KDdvVJaHCeC_N7UAq+PFETsQmkg@mail.gmail.com>
References: <1389011352-11449-1-git-send-email-kristian.evensen@gmail.com>
	<20140106124227.GA7743@localhost>
	<CAKfDRXisUL5yBbU3bZfo52GxU96BamC75vPWsFvOYg7u8Jhs1w@mail.gmail.com>
	<20140106124944.GA7830@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f175.google.com ([209.85.192.175]:39987 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753292AbaAFPTm (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 10:19:42 -0500
Received: by mail-pd0-f175.google.com with SMTP id w10so18238421pde.20
        for <netfilter-devel@vger.kernel.org>; Mon, 06 Jan 2014 07:19:40 -0800 (PST)
In-Reply-To: <20140106124944.GA7830@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello again,

On Mon, Jan 6, 2014 at 1:49 PM, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
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

I have spent some time trying to figure out how to implement this
(with only one NFT_META_CONNMARK), but I can't quite figure it out.
Implementing get and set of ctmark is straight forward and already
working, but restore and save are causing me some problems. They are
both set statements, but the current grammar requires a set statement
to contain an expression. We can use the already existing bitwise
operators instead of the mask provided as an argument to xt_CONNMARK,
so neither save nor restore needs an argument.

I was wondering if you could share your thoughts when you wrote the
pseudo-code? Would an OK solution be to for example add two more
meta_keys and hard-code something like the following statements:
META CONNMARK_SAVE
{
meta_stmt_alloc(&@$, $2, 0);
}
META CONNMARK_RESTORE
{
meta_stmt_alloc(&@$, $2, 0);
}?

-Kristian
