From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [libnftables PATCH] set: xml: fix key_type parsing
Date: Thu, 5 Sep 2013 10:58:02 +0200
Message-ID: <CAOkSjBhSTxGXbMA3Yy2mt2JDCgc0eRDaRYjygRUNACrB4BKYZg@mail.gmail.com>
References: <20130904160324.19268.79096.stgit@nfdev.cica.es> <20130905085340.GA4317@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:54582 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763441Ab3IEI6X convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 5 Sep 2013 04:58:23 -0400
Received: by mail-lb0-f173.google.com with SMTP id o14so1414294lbi.32
        for <netfilter-devel@vger.kernel.org>; Thu, 05 Sep 2013 01:58:22 -0700 (PDT)
In-Reply-To: <20130905085340.GA4317@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 5 September 2013 10:53, Pablo Neira Ayuso <pablo@netfilter.org> wrot=
e:
> On Wed, Sep 04, 2013 at 06:03:25PM +0200, Arturo Borrero Gonzalez wro=
te:
>> Bug introduced by myself at 44928cd5 [set: add XML parsing]
>
> Applied.
>
> Please, investigate why the json/xml test infrastructure did not catc=
h
> up this. Thanks.

The current testfiles for set uses the same value both in key_type and =
key_len.

In fact, I discovered this bug using nft-parsing-test, but with
others, additional files.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
