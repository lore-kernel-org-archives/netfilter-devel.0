From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [RFC nft PATCH] syntax: replace '=>' with '=:'
Date: Sun, 12 Jan 2014 22:47:01 +0100
Message-ID: <CAOkSjBghK7xhMpQHU48siS7GGzj+RhawK3dOLGLTxopZBv1=VA@mail.gmail.com>
References: <20140112194132.7369.3907.stgit@nfdev.cica.es> <20140112201742.GC13545@macbook.localnet>
 <CAOkSjBiSMubzv=eTou5O7W9mW_h=w77-iaMcCNCGMECLCQn2Hg@mail.gmail.com> <20140112212454.GA15677@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:58560 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751066AbaALVrZ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 12 Jan 2014 16:47:25 -0500
Received: by mail-la0-f51.google.com with SMTP id ec20so4667659lab.10
        for <netfilter-devel@vger.kernel.org>; Sun, 12 Jan 2014 13:47:22 -0800 (PST)
In-Reply-To: <20140112212454.GA15677@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 12 January 2014 22:24, Patrick McHardy <kaber@trash.net> wrote:
>
> IPv6 addresses are recognized by the parser, so it should be fine. I =
just
> compile tested this patch, at least bison doesn't report any errors.
>

'=3D:' works also as a visual separator.

If using ':', in the case of IPv6, we can end with:
2a00:9ac0:c1ca:27::150:123

Bison may detect it wisely, but I don't know where the address
start/ends, don't you?

Or we can force/require a space in the syntax:
2a00:9ac0:c1ca:27::150 : 123

If we decide to use ':', this last case is better, IMHO.

If you don't like '=3D:', what about:
'--'
'-:'
'---'
'--:'
or
':--'

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
