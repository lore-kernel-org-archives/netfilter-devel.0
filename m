From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [libnftables] nft_*_attr_unset() functions
Date: Wed, 5 Jun 2013 01:03:37 +0200
Message-ID: <CAOkSjBjRaVvRxX6e9tVMnz5Q2QAVxfAaVhs8edBrrg42FR4OeA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f182.google.com ([209.85.217.182]:54811 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755100Ab3FDXD7 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 4 Jun 2013 19:03:59 -0400
Received: by mail-lb0-f182.google.com with SMTP id r11so192373lbv.41
        for <netfilter-devel@vger.kernel.org>; Tue, 04 Jun 2013 16:03:58 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

How do you see having nft_{table|chain|rule}_attr_unset() functions so
we can unset some object attributes?

I find this useful for chain&rule XML code examples, where kernel is
returning error due to handle already set.

Regards.
--
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
