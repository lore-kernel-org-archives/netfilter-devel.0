From: Patrick McHardy <kaber@trash.net>
Subject: Re: [nft] using `nft -i' as user shell
Date: Fri, 26 Sep 2014 19:44:19 +0200
Message-ID: <A1298022-5A91-49B3-9AF1-57C18B9A8CA4@trash.net>
References: <CAOkSjBhK9jSYV4+zuWGP-nCmEe9b1D0TyMrqORYJH+D_Y4VRag@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain;
 charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>,
	Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:45613 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755789AbaIZRob (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 26 Sep 2014 13:44:31 -0400
In-Reply-To: <CAOkSjBhK9jSYV4+zuWGP-nCmEe9b1D0TyMrqORYJH+D_Y4VRag@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Am 26. September 2014 19:18:57 MESZ, schrieb Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>:
>Hi!
>
>I've playing with the use of `nft -i' as user shell.
>This would be handy to let some users log just to manage the nftables
>ruleset.
>
>In some situations, the CLI may block (or takes long time to return),
>and the only way to kill the running command is hitting CTRL+C, which
>also kills the interactive mode, which logs out the user of the
>system.
>
>Cases with this issue:
> * massive listings.
> * listings with lots of DNS queries
> * monitor.
>
>A possible solution would be to implement a signal handler, somehow
>integrated with libreadline. However i'm totally ignorant if this is
>possible and/or how to do it.
>
>What do you think?

It sounds like the right solution and shouldn't be too hard :) Not within readline though, IIRC we do non-blocking I/O anyways, so it should be relatively easy.

>
>regards.


