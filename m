From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 02/02]: ip_tables: fix compat copy race
Date: Wed, 12 Dec 2007 10:35:36 -0800 (PST)
Message-ID: <20071212.103536.171818071.davem@davemloft.net>
References: <20071211174205.1042.29518.sendpatchset@localhost.localdomain>
	<20071211174208.1042.41041.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:33424
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1753425AbXLLSfh (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 12 Dec 2007 13:35:37 -0500
In-Reply-To: <20071211174208.1042.41041.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Tue, 11 Dec 2007 18:42:11 +0100 (MET)

> [NETFILTER]: ip_tables: fix compat copy race
> 
> When copying entries to user, the kernel makes two passes through the
> data, first copying all the entries, then fixing up names and counters.
> On the second pass it copies the kernel and match data from userspace
> to the kernel again to find the corresponding structures, expecting
> that kernel pointers contained in the data are still valid.
> 
> This is obviously broken, fix by avoiding the second pass completely
> and fixing names and counters while dumping the ruleset, using the
> kernel-internal data structures.
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Also applied to net-2.6, thanks Patrick!
