From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 4/6] internal: add a selector for parsing ops
Date: Wed, 8 Jan 2014 13:31:44 +0100
Message-ID: <CAOkSjBiOw10oK4stjz48yqF63+Y_8-hOoH-uUh4FqO2e7P2DVA@mail.gmail.com>
References: <20140107114518.12841.35778.stgit@nfdev.cica.es>
 <20140107114732.12841.11957.stgit@nfdev.cica.es> <20140107232919.GD16894@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f50.google.com ([209.85.215.50]:59469 "EHLO
	mail-la0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755546AbaAHMcG convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jan 2014 07:32:06 -0500
Received: by mail-la0-f50.google.com with SMTP id el20so1071328lab.37
        for <netfilter-devel@vger.kernel.org>; Wed, 08 Jan 2014 04:32:05 -0800 (PST)
In-Reply-To: <20140107232919.GD16894@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 8 January 2014 00:29, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
>
> You should pass a callback function instead, eg.
>
> static int nft_chain_json_parse(struct nft_chain *c, const char *json=
,
>                                 struct nft_parse_err *err,
>                                 json_t *(*jsonbuilder)(const void *in=
put_data,
>                                                        const char *tr=
eename,
>                                                        struct nft_par=
se_err *e))

Ok.

> But I don't understand yet what you save (in terms of lines of code)
> by using this aproach.

I avoid doing something like:

nft_*_parse() {
switch (type)
 if XML return xml_parse()
 if JSON return json_parse()
}

nft_*_parse_file() {
switch (type)
 if XML return xml_parse_file()
 if JSON return json_parse_file()
}

We double the format switch, and also two functions per format are
needed to do build and parsing.
Total =3D 6 functions heavily duplicating code.

With my approach, we have 1 function that decides which format to
parse, and a one function per format to build and do parsing.
Total =3D 3 functions, no duplicate code.
--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
