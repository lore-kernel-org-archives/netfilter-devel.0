From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [nftables] goto vs jump documentation
Date: Tue, 24 Nov 2015 16:56:35 +0100
Message-ID: <20151124155635.GA13734@salvia>
References: <CAOkSjBiEzMwQoKfZ-SbptULO_NHZUgoO=KELDO-2CNEFKiof_w@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:51840 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbbKXP4q (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Nov 2015 10:56:46 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C7671B6BAE
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 16:56:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id B91B1DA803
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 16:56:42 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id D056DDA81D
	for <netfilter-devel@vger.kernel.org>; Tue, 24 Nov 2015 16:56:40 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBiEzMwQoKfZ-SbptULO_NHZUgoO=KELDO-2CNEFKiof_w@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Nov 20, 2015 at 02:45:31PM +0100, Arturo Borrero Gonzalez wrote:
> Hi,
> 
> I've documented the difference between goto and jump in the nftables wiki [0].
> 
> Let me know if that's OK.

This looks good.

I'd suggest you place this into add this into a new article:

"Going to chain"

just after the existing "Jumping to chain". No changes in the content,
I like that you use the jump concept as reference to explain this new
one.
