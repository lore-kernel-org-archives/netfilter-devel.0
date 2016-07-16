From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH V2 iptables] extensions: libxt_connlabel: Add translation
 to nft
Date: Sat, 16 Jul 2016 16:51:30 +0200
Message-ID: <20160716145130.GA2307@salvia>
References: <1468665744-21839-1-git-send-email-zlpnobody@163.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, fw@strlen.de,
	Liping Zhang <liping.zhang@spreadtrum.com>
To: Liping Zhang <zlpnobody@163.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:39001 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751593AbcGPOve (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 16 Jul 2016 10:51:34 -0400
Received: from antivirus1-rhel7.int (unknown [192.168.2.11])
	by mail.us.es (Postfix) with ESMTP id 73DDF114801
	for <netfilter-devel@vger.kernel.org>; Sat, 16 Jul 2016 16:51:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 650814E55B
	for <netfilter-devel@vger.kernel.org>; Sat, 16 Jul 2016 16:51:33 +0200 (CEST)
Received: from antivirus1-rhel7.int (localhost [127.0.0.1])
	by antivirus1-rhel7.int (Postfix) with ESMTP id 67C0E6449C
	for <netfilter-devel@vger.kernel.org>; Sat, 16 Jul 2016 16:51:31 +0200 (CEST)
Content-Disposition: inline
In-Reply-To: <1468665744-21839-1-git-send-email-zlpnobody@163.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Sat, Jul 16, 2016 at 06:42:24PM +0800, Liping Zhang wrote:
>   # iptables-translate -A INPUT -m connlabel ! --label bit40 --set
>   nft add rule ip filter INPUT ct label set bit40 ct label and bit40 != bit40 counter

I think this logic is inverted, I mean:

nft add rule ip filter INPUT ct label and bit40 != bit40 ct label set bit40 counter
                             ---------------------------

test should happen before set.
