From: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Subject: [nft] using `nft -i' as user shell
Date: Fri, 26 Sep 2014 19:18:57 +0200
Message-ID: <CAOkSjBhK9jSYV4+zuWGP-nCmEe9b1D0TyMrqORYJH+D_Y4VRag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Patrick McHardy <kaber@trash.net>,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-qc0-f177.google.com ([209.85.216.177]:64003 "EHLO
	mail-qc0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755638AbaIZRTS convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:19:18 -0400
Received: by mail-qc0-f177.google.com with SMTP id x13so6993788qcv.8
        for <netfilter-devel@vger.kernel.org>; Fri, 26 Sep 2014 10:19:17 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi!

I've playing with the use of `nft -i' as user shell.
This would be handy to let some users log just to manage the nftables r=
uleset.

In some situations, the CLI may block (or takes long time to return),
and the only way to kill the running command is hitting CTRL+C, which
also kills the interactive mode, which logs out the user of the
system.

Cases with this issue:
 * massive listings.
 * listings with lots of DNS queries
 * monitor.

A possible solution would be to implement a signal handler, somehow
integrated with libreadline. However i'm totally ignorant if this is
possible and/or how to do it.

What do you think?

regards.
--=20
Arturo Borrero Gonz=C3=A1lez
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
