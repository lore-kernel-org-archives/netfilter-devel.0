From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] ip6: Add tests for icmpv6 packet types
Date: Wed, 20 Jan 2016 14:54:21 +0100
Message-ID: <20160120135421.GA13352@salvia>
References: <20160118191448.GA10814@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60959 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932261AbcATNyZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 20 Jan 2016 08:54:25 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 31651303D1C
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 14:54:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 23E40DA80C
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 14:54:24 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 5D9E3DA843
	for <netfilter-devel@vger.kernel.org>; Wed, 20 Jan 2016 14:54:22 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20160118191448.GA10814@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Jan 19, 2016 at 12:44:48AM +0530, Shivani Bhardwaj wrote:
> Add tests for the icmpv6 packet types policy-fail and reject-route to be
> used with REJECT target.

Applied, thanks Shivani.
