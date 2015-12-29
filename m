From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC PATCH nft] parser: re-try unexpected tokens as symbol
 expression
Date: Wed, 30 Dec 2015 00:42:34 +0100
Message-ID: <20151229234234.GA1386@salvia>
References: <1451425319-11715-1-git-send-email-fw@strlen.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Florian Westphal <fw@strlen.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43801 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752951AbbL2Xmk (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 29 Dec 2015 18:42:40 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 3E6A61022AC
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 00:42:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3018EDA801
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 00:42:38 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 16E67DA795
	for <netfilter-devel@vger.kernel.org>; Wed, 30 Dec 2015 00:42:36 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1451425319-11715-1-git-send-email-fw@strlen.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Dec 29, 2015 at 10:41:59PM +0100, Florian Westphal wrote:
> nft fails to parse certain corner-cases, for example:
> 
> nft add rule filter input meta rtclassid daddr
> 
> ... as it finds DADDR token.  However, 'daddr' might be a valid
> routing realm listed in iproute2/rt_realms, so this should be allowed.

We should probably have a look at lex "start conditions" [1]. I think
it's possible to disable scanner rules from the parser based on our
context via yy_push_state(), thus the scanner rules are
enabled/disabled. With the patchset I have just posted, we know have a
rule for specific constant rhs of the relational.

[1] https://www.freebsd.org/cgi/man.cgi?query=lex&sektion=1
