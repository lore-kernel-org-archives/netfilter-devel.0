From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/3] bridge: netfilter: checkpatch data type fixes
Date: Tue, 7 Jun 2016 17:19:04 +0200
Message-ID: <20160607151904.GA23655@salvia>
References: <1462843618-21914-1-git-send-email-me@tobin.cc>
 <1462843618-21914-3-git-send-email-me@tobin.cc>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Stephen Hemminger <stephen@networkplumber.org>,
	"David S. Miller" <davem@davemloft.net>,
	netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
	netdev@vger.kernel.org
To: tcharding <me@tobin.cc>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:57610 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1161527AbcFGPT1 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 7 Jun 2016 11:19:27 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 1277E92176F
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:19:26 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 002A3158F37
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:19:25 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 1A299158F26
	for <netfilter-devel@vger.kernel.org>; Tue,  7 Jun 2016 17:19:07 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1462843618-21914-3-git-send-email-me@tobin.cc>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, May 10, 2016 at 11:26:57AM +1000, tcharding wrote:
> From: Tobin C Harding <me@tobin.cc>
> 
> checkpatch produces data type 'checks'.
> 
> This patch amends them by changing, for example:
> uint8_t -> u8

This looks good. Applied, thanks.
