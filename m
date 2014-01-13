From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH] files: replace interpreter during installation
Date: Mon, 13 Jan 2014 10:49:51 +0100
Message-ID: <CAOkSjBgTH=De81npZv_6P6B3rxJxt_0DW6yzK=pzp8uD03TpjA@mail.gmail.com>
References: <20140113091623.10582.14579.stgit@nfdev.cica.es> <20140113093912.GA14898@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f48.google.com ([209.85.215.48]:48550 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750955AbaAMJuM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 13 Jan 2014 04:50:12 -0500
Received: by mail-la0-f48.google.com with SMTP id er20so658023lab.21
        for <netfilter-devel@vger.kernel.org>; Mon, 13 Jan 2014 01:50:11 -0800 (PST)
In-Reply-To: <20140113093912.GA14898@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 13 January 2014 10:39, Patrick McHardy <kaber@trash.net> wrote:
>
> I think we should use .in files instead and perform variable substiti=
on.
>

Could you please elaborate this?

I have understood:

Use a variable in files/nftables/*, like:
<<
$shebang

table filter {
[...]

>>

And replace during install. Is this true?

regards
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
