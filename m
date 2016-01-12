From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: parser regression: '/' symbol
Date: Tue, 12 Jan 2016 13:52:11 +0100
Message-ID: <20160112125211.GA19306@salvia>
References: <CAOkSjBjytRTvdri+g-EGutvrFWsNuRAK5qgffWDVpm-3-X34mA@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailing list
	<netfilter-devel@vger.kernel.org>, Florian Westphal <fw@strlen.de>
To: Arturo Borrero Gonzalez <arturo.borrero.glez@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:37347 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752603AbcALMwP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 12 Jan 2016 07:52:15 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id AA40D130FD2
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 13:52:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9BC67DA803
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 13:52:14 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 35A4ADA803
	for <netfilter-devel@vger.kernel.org>; Tue, 12 Jan 2016 13:52:12 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <CAOkSjBjytRTvdri+g-EGutvrFWsNuRAK5qgffWDVpm-3-X34mA@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 12, 2016 at 12:09:49PM +0100, Arturo Borrero Gonzalez wrote:
> Hi,
> 
> I've detected a regression using defines in a file:
> 
> define network = 1.1.1.1/24
> 
> and then loading it with `nft -f'.
> 
> The error is:
> 'Error: syntax error, unexpected /, expecting newline or semicolon'
> 
> Florian suspects of commit 2a5d44d8b3c88018165d736c9582cebbf40e6362
> (parser: get rid of multiton_expr from lhs relational expression).

Just sent you a patch, let me know if it resolves the problem.

A test to catch this would be great :)
