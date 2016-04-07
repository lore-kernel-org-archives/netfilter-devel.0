From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/1] net: netfilter: Fix stack out of bounds when parsing
 TCP options
Date: Thu, 7 Apr 2016 18:43:11 +0200
Message-ID: <20160407164311.GA2535@salvia>
References: <1459330475-2220-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1459330475-2220-2-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:52330 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752235AbcDGQnP (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 7 Apr 2016 12:43:15 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 594574B0F6
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 18:43:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 4972ADA8FB
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 18:43:13 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 3A61DDA38E
	for <netfilter-devel@vger.kernel.org>; Thu,  7 Apr 2016 18:43:11 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1459330475-2220-2-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 30, 2016 at 11:34:35AM +0200, Jozsef Kadlecsik wrote:
> Baozeng Ding reported a KASAN stack out of bounds issue - it uncovered that
> the TCP option parsing routines in netfilter TCP connection tracking could
> read one byte out of the buffer of the TCP options.  Therefore in the patch
> we check that the available data length is large enough to parse both TCP
> option code and size.

Applied, thanks Jozsef.
