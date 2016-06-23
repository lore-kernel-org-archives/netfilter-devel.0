From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nf-next] netfilter: nf_log: Remove NULL check
Date: Thu, 23 Jun 2016 19:39:19 +0200
Message-ID: <20160623173919.GA3562@salvia>
References: <20160611185610.GA3374@shivani>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Shivani Bhardwaj <shivanib134@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56673 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751447AbcFWRjX (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Jun 2016 13:39:23 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 266568D051B
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:39:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1609A9EBA0
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:39:22 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 093109EBAD
	for <netfilter-devel@vger.kernel.org>; Thu, 23 Jun 2016 19:39:20 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <20160611185610.GA3374@shivani>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sun, Jun 12, 2016 at 12:26:10AM +0530, Shivani Bhardwaj wrote:
> If 'logger' was NULL, there would be a direct jump to the label 'out',
> since it has already been checked for NULL, remove this unnecessary
> check.

Applied, thanks Shivani.
