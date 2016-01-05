From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft PATCH 2/4] rule: when listing all sets, don't print empty tables
Date: Tue, 5 Jan 2016 13:10:51 +0100
Message-ID: <CAOkSjBgWR29VdnN8TcPdHRGVh=BKM0m1wiDLzKQTGyhPXwtK0g@mail.gmail.com>
References: <145190990642.22285.2420592085262978551.stgit@r2d2.cica.es>
 <145190991185.22285.13328538132434564559.stgit@r2d2.cica.es>
 <20160105113544.GA9098@salvia> <20160105114029.GB9098@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f50.google.com ([74.125.82.50]:33296 "EHLO
	mail-wm0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751456AbcAEMLM convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 5 Jan 2016 07:11:12 -0500
Received: by mail-wm0-f50.google.com with SMTP id f206so20598793wmf.0
        for <netfilter-devel@vger.kernel.org>; Tue, 05 Jan 2016 04:11:12 -0800 (PST)
In-Reply-To: <20160105114029.GB9098@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 5 January 2016 at 12:40, Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
>
> I'm going to keep this back.
>
> We have to provide a consistent behaviour wrt. nft list chains, and
> that is listing empty tables when it contains no chains.
>
> I'm unsure here, I considering printing the table with no content
> makes sense since the user knows no sets or chains are available
> there. If we skip this, it looks like the table doesn't exists. Other
> than that, the user is fully aware of having a table with no content.

Ok, I understand, thanks.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
