From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: xtables-addons git repo inaccessible
Date: Tue, 19 Aug 2008 17:13:15 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808191711210.28534@fbirervta.pbzchgretzou.qr>
References: <38bcb3ec0808191343m5052813fsfc7b798ea5f84252@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Development Mailinglist
	<netfilter-devel@vger.kernel.org>
To: James King <t.james.king@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:42720 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753366AbYHSVNR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 19 Aug 2008 17:13:17 -0400
In-Reply-To: <38bcb3ec0808191343m5052813fsfc7b798ea5f84252@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Tuesday 2008-08-19 16:43, James King wrote:
>
>Attempting to pull or clone off of your xtables-addons repo (indeed
>any repo on git://dev.medozas.de) is currently failing:
>
>$ git pull
>fatal: The remote end hung up unexpectedly
>
>$ git clone git://dev.medozas.de/xtables-addons
>Initialized empty Git repository in /usr/src/git/a/xtables-addons/.git/
>fatal: read error (Connection reset by peer)
>fetch-pack from 'git://dev.medozas.de/xtables-addons' failed.

Git 1.6.0 update -- hooray! *snicker* forgot to update /etc/xinetd.d/git 
to use the new path /usr/libexec/git-core, works now again. Thanks for 
noticing!

