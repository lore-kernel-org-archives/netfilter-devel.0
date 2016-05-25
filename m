From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v3] doc: Complete the documentation of statements
Date: Wed, 25 May 2016 12:01:38 +0200
Message-ID: <20160525100138.GA11028@salvia>
References: <20160512112714.GA10290@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46881 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbcEYKBs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 May 2016 06:01:48 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 0D7F6178584
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 12:01:46 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id F21C511FE80
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 12:01:45 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 9C46F11FE80
	for <netfilter-devel@vger.kernel.org>; Wed, 25 May 2016 12:01:40 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160512112714.GA10290@shivani>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, May 12, 2016 at 04:57:14PM +0530, Shivani Bhardwaj wrote:
> Add documentation corresponding to LOG STATEMENT, REJECT STATEMENT,
> COUNTER STATEMENT, META STATEMENT, LIMIT STATEMENT, NAT STATEMENT,
> QUEUE STATEMENT.

We're almost there. Look, this syntax the manpage shows after your
update is not correct:

   LIMIT STATEMENT
       limit {rate | burst}

This should look like:

        limit rate [over] _rate_ [units] [burst _burst_ ]

Have a look at 'limit_stmt' in src/parser_bison.y for the production
in the grammar that we have. This should show what is there.

Would you give this another spin?

Thanks.
