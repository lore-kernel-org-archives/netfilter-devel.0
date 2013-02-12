From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: limit the number of source ips connected?
Date: Wed, 13 Feb 2013 00:21:59 +0100
Message-ID: <CAOkSjBhpAKgcL84GtT_+1cC6E2GuKAKPvmo9PUGGhiDFEsfZ3g@mail.gmail.com>
References: <CAO2+3OwER9htP0Of2GzF=jTb3AN3gFhZ6cv3EZ7zFCubFUekTA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: netfilter-devel@vger.kernel.org
To: Jose Luis Godoy <joseluis.gms@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f173.google.com ([209.85.217.173]:52756 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754500Ab3BLXWW convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Feb 2013 18:22:22 -0500
Received: by mail-lb0-f173.google.com with SMTP id gf7so522277lbb.18
        for <netfilter-devel@vger.kernel.org>; Tue, 12 Feb 2013 15:22:20 -0800 (PST)
In-Reply-To: <CAO2+3OwER9htP0Of2GzF=jTb3AN3gFhZ6cv3EZ7zFCubFUekTA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

2013/2/12 Jose Luis Godoy <joseluis.gms@gmail.com>:
> I would like to know if it is possible to set a rule to limit the
> number of source ips connected, like in BSD Packet Filter, option
> 'max-src-nodes'.

Hi Jose Luis,

I think you are looking for "recent" module (see iptables(8) for option=
s)

Also, I would try doing the trick using ipset utility. You could fill
a set until certain limit and drop traffic not coming from some IP
within the set.

Regards.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
