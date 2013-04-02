From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH 2/2] Basic support for printing nft_data_reg
 in XML format.
Date: Tue, 2 Apr 2013 19:18:39 +0200
Message-ID: <CAOkSjBjM57H+XAX7h5YFOPcfF_Hj3H_vfnMpBg6tnQVTee1CKA@mail.gmail.com>
References: <20130329153155.30122.21803.stgit@nfdev.cica.es>
 <20130329153432.30122.86772.stgit@nfdev.cica.es> <20130402114123.GC9973@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f181.google.com ([209.85.217.181]:33045 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762015Ab3DBRTB convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:19:01 -0400
Received: by mail-lb0-f181.google.com with SMTP id r11so708537lbv.26
        for <netfilter-devel@vger.kernel.org>; Tue, 02 Apr 2013 10:19:00 -0700 (PDT)
In-Reply-To: <20130402114123.GC9973@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/4/2 Pablo Neira Ayuso <pablo@netfilter.org>:
> I think we need something similar to:
>
> int nft_parse_data(union nft_data_reg *data, struct nlattr *attr, int=
 *type);
>
> We should pass a 'type' that indicates:
>
>         DATA_VALUE,
>         DATA_VERDICT,
>         DATA_CHAIN,
>
> So you know if you have print what the data_reg contains.
>

If cmp and bitwise are going to always have DATA_VALUE, and imm
depending on what was set, I think we could do:

int nft_data_reg_snprintf(char *buf, union data_reg *data, int type, ..=
=2E)
switch(type)
return nft_data_reg_snprintf_'type'(buf, data, ...)

And the same applies when parsing XML.

Is this true?

If this is not the case, I think I didn't understand.
--
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
