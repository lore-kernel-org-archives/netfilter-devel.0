From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] add JSON output format
Date: Mon, 29 Feb 2016 12:43:43 +0100
Message-ID: <20160229114343.GA11451@salvia>
References: <1456132337-23426-1-git-send-email-laforge@gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46356 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753820AbcB2Lny (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 29 Feb 2016 06:43:54 -0500
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1AB5C4B9E8
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 12:43:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 0A933DA384
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 12:43:51 +0100 (CET)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4709ADA384
	for <netfilter-devel@vger.kernel.org>; Mon, 29 Feb 2016 12:43:45 +0100 (CET)
Content-Disposition: inline
In-Reply-To: <1456132337-23426-1-git-send-email-laforge@gnumonks.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Feb 22, 2016 at 10:12:17AM +0100, Harald Welte wrote:
> the original output format looks a bit like JSON, but isn't.  The XML
> output is useful if you deal with XML, but a lot of applications prefer
> more lightweight formats like YAML/JSON.
> 
> This adds the JSON output format to libnetfilter_acct, which will
> subsequently be used by a similar change in the nfacct utility.

Applied, thanks Harald!
