From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: Can't compile nftables
Date: Tue, 21 Jan 2014 14:25:48 +0100
Message-ID: <CAOkSjBjr1CV9gFqWA08zF=K6E7rZTUBWjyVMuGJh8Oo6Se_U5g@mail.gmail.com>
References: <CAOkSjBiG2dXFKves3yf61Lw2gP=EBC=auAaTJL8HApGmc8O7PA@mail.gmail.com>
 <20140121123559.GD30955@macbook.localnet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f179.google.com ([209.85.217.179]:43612 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754640AbaAUN0J convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 21 Jan 2014 08:26:09 -0500
Received: by mail-lb0-f179.google.com with SMTP id l4so4232005lbv.24
        for <netfilter-devel@vger.kernel.org>; Tue, 21 Jan 2014 05:26:08 -0800 (PST)
In-Reply-To: <20140121123559.GD30955@macbook.localnet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 21 January 2014 13:36, Patrick McHardy <kaber@trash.net> wrote:
>
> You need to run ldconfig after installing the libraries, otherwise th=
e
> malloc test will fail and autoconf will replace it by rpl_*.

I think this did the trick.

thanks

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
