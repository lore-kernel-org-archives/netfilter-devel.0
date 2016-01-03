From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH v2] iptables: nft-ipv6: Replace ip with ip6
Date: Sun, 3 Jan 2016 21:14:43 +0100
Message-ID: <20160103201443.GB12055@salvia>
References: <20151230053808.GA3717@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:43191 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751245AbcACUOr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 3 Jan 2016 15:14:47 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id C7C031022A1
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 21:14:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id BA005DA801
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 21:14:46 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id DE1DCDA801
	for <netfilter-devel@vger.kernel.org>; Sun,  3 Jan 2016 21:14:44 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <20151230053808.GA3717@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Dec 30, 2015 at 11:08:08AM +0530, Shivani Bhardwaj wrote:
> Replace ip with ip6 to avoid conflict between the protocols in the
> results obtained from ip6tables-translate utility.

Applied, thanks Shivani.
