From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nf-next/nf_tables8] Unable to compile kernel
Date: Tue, 19 Feb 2013 00:12:13 +0100
Message-ID: <CAOkSjBhoFNRd9vdVyCXk-joKG=-oxuAkOmJ93nGHfFmvneWSpw@mail.gmail.com>
References: <CAOkSjBh78knOWQLmFnz+XyW4umVVnVVkWs9VeYPJdzhxg3T_fg@mail.gmail.com>
 <20130218165952.GA19904@localhost> <CAOkSjBjHQhgM0SB7cnXKpZ03nNvdK8NCVyUf+Po-jopOViAQvw@mail.gmail.com>
 <CAOkSjBhL6hgA8fHxE+W3yTLnXMfJja24JjLJSvbbfg2wC0rt8w@mail.gmail.com>
 <20130218172843.GA29465@localhost> <CAOkSjBiKh399=YO4U=mAOz9ACuBidDWWa3CHhEQO4QtZ15AQ7A@mail.gmail.com>
 <CAOkSjBiXdiaDTUdOH2HnHWmyqRpX_-+hXWh8Q_-13oe20c2ZaA@mail.gmail.com> <20130218220803.GA30353@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:43918 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753820Ab3BRXMe convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 18 Feb 2013 18:12:34 -0500
Received: by mail-lb0-f182.google.com with SMTP id gg6so4676295lbb.27
        for <netfilter-devel@vger.kernel.org>; Mon, 18 Feb 2013 15:12:33 -0800 (PST)
In-Reply-To: <20130218220803.GA30353@localhost>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/2/18 Pablo Neira Ayuso <pablo@netfilter.org>:
> Please, try: CONFIG_NF_TABLES_IPV6=3Dm
>
> I don't see CONFIG_NFT_EXTHDR, make sure it's also =3Dm.
>

Ok, all went fine this time.

thanks.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
