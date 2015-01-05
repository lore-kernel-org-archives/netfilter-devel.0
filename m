From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: Re: [nft-sync PATCH 2/3] mnl: sync source code with nft
Date: Mon, 5 Jan 2015 13:17:54 +0100
Message-ID: <CAOkSjBhZ_mPqeS8B+ezn9-8mc0wdjBhBeQ9zNG3xzVMcCcPK6g@mail.gmail.com>
References: <20141226125122.16382.30213.stgit@nfdev.cica.es>
 <20141226125127.16382.40927.stgit@nfdev.cica.es> <20150105112910.GB13289@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f47.google.com ([209.85.215.47]:45357 "EHLO
	mail-la0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751252AbbAEMSQ convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Jan 2015 07:18:16 -0500
Received: by mail-la0-f47.google.com with SMTP id hz20so18352694lab.34
        for <netfilter-devel@vger.kernel.org>; Mon, 05 Jan 2015 04:18:15 -0800 (PST)
In-Reply-To: <20150105112910.GB13289@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 5 January 2015 at 12:29, Pablo Neira Ayuso <pablo@netfilter.org> wro=
te:
>
> We should also start abstracting and moving things to the library in =
a
> way that nft-sync can reuse, so we avoid code redundancy.

Ok, I like that path.

I tried it once (a patch series called mnlio, some time ago). I will
try again :-)
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
