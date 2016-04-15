From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH libnftnl] tests: nat-test: Use different values to test
Date: Fri, 15 Apr 2016 12:45:55 +0200
Message-ID: <20160415104555.GA10918@salvia>
References: <20160415081257.GA3489@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:34343 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753195AbcDOKqV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 15 Apr 2016 06:46:21 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id EFC88114816
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:46:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DFE369D0E2
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:46:18 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 2DAF99D0E2
	for <netfilter-devel@vger.kernel.org>; Fri, 15 Apr 2016 12:46:13 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160415081257.GA3489@shivani>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Apr 15, 2016 at 01:42:57PM +0530, Shivani Bhardwaj wrote:
> Tests are more effective if different values are set so, use different
> values for every expression.

Good point. Applied, thanks.
