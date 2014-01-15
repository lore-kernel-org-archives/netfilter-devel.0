From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [PATCH 1/2 nft RFC] expression: default to print binary
 operations using nominal representation
Date: Wed, 15 Jan 2014 12:32:36 +0100
Message-ID: <CAOkSjBg+on2TzybwdyaL+foReRgHZ4vA981JLZs4E0k9Dfe3aA@mail.gmail.com>
References: <1389784167-10198-1-git-send-email-pablo@netfilter.org> <20140115111803.GA17728@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Pablo Neira Ayuso <pablo@netfilter.org>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:34175 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750928AbaAOLdC convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Jan 2014 06:33:02 -0500
Received: by mail-lb0-f181.google.com with SMTP id z5so657752lbh.40
        for <netfilter-devel@vger.kernel.org>; Wed, 15 Jan 2014 03:33:00 -0800 (PST)
In-Reply-To: <20140115111803.GA17728@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 15 January 2014 12:18, Patrick McHardy <kaber@trash.net> wrote:
> On Wed, Jan 15, 2014 at 12:09:26PM +0100, Pablo Neira Ayuso wrote:
>> Since b59e65c ("scanner: add aliases to symbols for easier
>> interaction with most shells") we have nominal aliases, default to
>> these for the output representation.
>
> I was thinking about this before, but didn't mention it since you
> hadn't included it in your first patch. I'd prefer to stick to the
> IMO more readable existing form. Since we don't support deleting
> rules by rule specification, there should be no reason to copy and
> paste the output to the command line again.

What about a file to be loaded with `nft -f'?
In fact, I think most of users will end with a config file to load
with `nft -f'.

It may be annoying getting the output different to what you wrote.

I think this patch means that the symbol-free syntax is the default,
and I personally like that.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
