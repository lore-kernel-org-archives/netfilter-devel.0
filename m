From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nftables] rebase next-3.14
Date: Mon, 3 Feb 2014 13:20:04 +0100
Message-ID: <CAOkSjBhkhWXiazqonNd+eN=+Mb473xH_WZCtaycB=w9YEO61oA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-la0-f51.google.com ([209.85.215.51]:36221 "EHLO
	mail-la0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750852AbaBCMU0 convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 3 Feb 2014 07:20:26 -0500
Received: by mail-la0-f51.google.com with SMTP id c6so5211660lan.24
        for <netfilter-devel@vger.kernel.org>; Mon, 03 Feb 2014 04:20:24 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi there!

Would you consider rebasing libnftnl/nftables next-3.14?

Some important changes happened in the master branch that are needed
in next-3.14.

It's hard to build the next-3.14 branch, because libnftnl deploys
include files in 'include/libnftables' and nftables expects
'include/libnftnl'.

The libnftnl rebase is going to be painful, let me know if I can help.

regards.

--=20
Arturo Borrero Gonz=E1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
