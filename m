From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: [PATCH] Update pom-ng docs for new iptables snapshots
Date: Sat, 2 Aug 2008 20:12:47 -0400 (EDT)
Message-ID: <alpine.LNX.1.10.0808022011460.21001@fbirervta.pbzchgretzou.qr>
References: <20080802234156.GA26595@linuxace.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Phil Oester <kernel@linuxace.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from sovereign.computergmbh.de ([85.214.69.204]:38940 "EHLO
	sovereign.computergmbh.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751791AbYHCAMt (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Aug 2008 20:12:49 -0400
In-Reply-To: <20080802234156.GA26595@linuxace.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Saturday 2008-08-02 19:41, Phil Oester wrote:

>Attempting to run pom-ng's runme against an iptables snapshot
>which has not yet had release.sh run in it will fail.  Update
>docs to reflect this.
>
>This closes bugzilla #538.

I'd rather address it by stating its seemingly obsoletedness that
has been discussed in previous threads.
In other words, `svn rm * && svn commit`, and keep the repository
for history.
