From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nftables] handle when adding new chain/rule
Date: Tue, 28 May 2013 16:59:05 +0200
Message-ID: <CAOkSjBjqf6y3zbmY67VF6zgfY_pf-9_wGF0v-fFt6BonWnTaig@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f52.google.com ([209.85.215.52]:55626 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934457Ab3E1O71 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 May 2013 10:59:27 -0400
Received: by mail-la0-f52.google.com with SMTP id fo13so7596735lab.11
        for <netfilter-devel@vger.kernel.org>; Tue, 28 May 2013 07:59:25 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Pablo,

I think the issue we saw when adding new chain with a given handle
also occurs with rules:

net/netfilter/nf_tables_api.c -- about line 838
net/netfilter/nf_tables_api.c -- about line 1560

I see that the kernel is intended to allocate a new handle in both
cases (chain & rule), calling nf_tables_alloc_handle().

My personal thought is that this may be problematic, dont you? How to f=
ace this?

Regards.
--
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
