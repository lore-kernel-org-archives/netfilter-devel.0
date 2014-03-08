From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] userspace SSDP conntrack helper
Date: Sat, 8 Mar 2014 17:39:02 +0100
Message-ID: <20140308163902.GA3590@localhost>
References: <531B3E73.3080801@blueyonder.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Ash Hughes <ashley.hughes@blueyonder.co.uk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52348 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751130AbaCHQjK (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 8 Mar 2014 11:39:10 -0500
Content-Disposition: inline
In-Reply-To: <531B3E73.3080801@blueyonder.co.uk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

On Sat, Mar 08, 2014 at 03:59:47PM +0000, Ash Hughes wrote:
> Hi,
>=20
> Here is a patch which adds a userspace conntrack helper for the SSDP
> protocol. This is based on the code found at:
>=20
> http://marc.info/?t=3D132945775100001&r=3D1&w=3D2
>=20
> I'm not sure how to get my laptop to play at IPv6, so I've not tested
> this part, but I've tested the IPv4 section and it works. What more
> needs to be done to get this merged in? :)

A couple of things, first send me several pcap trace files with SSDP
traffic for this protocol for my personal database, I used them to
exercise this code.

Secondly, fix coding style:

http://lxr.free-electrons.com/source/Documentation/CodingStyle

Specifically, indentation is broken, your editor is converting tabs
into spaces.

And please, slightly extend the manual.

> diff --git a/src/helpers/Makefile.am b/src/helpers/Makefile.am
> index fe28e83..947e58b 100644
> --- a/src/helpers/Makefile.am
> +++ b/src/helpers/Makefile.am
> @@ -6,7 +6,8 @@ pkglib_LTLIBRARIES =3D ct_helper_amanda.la \
>  		     ct_helper_rpc.la	\
>  		     ct_helper_tftp.la	\
>  		     ct_helper_tns.la	\
> -		     ct_helper_sane.la
> +		     ct_helper_sane.la  \
> +             ct_helper_ssdp.la
   ^=E2=81=BB----------^

Same thing in the rest of the code.

Thanks.
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
