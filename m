From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 06/07]: nf_sockopts list head cleanup
Date: Mon, 05 Nov 2007 20:59:24 -0800 (PST)
Message-ID: <20071105.205924.57716843.davem@davemloft.net>
References: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
	<20071102112008.22803.12783.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:45739
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755197AbXKFE7Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2007 23:59:24 -0500
In-Reply-To: <20071102112008.22803.12783.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Fri,  2 Nov 2007 12:23:18 +0100 (MET)

> [NETFILTER]: nf_sockopts list head cleanup
> 
> Code is using knowledge that nf_sockopt_ops::list list_head is first
> field in structure by using casts. Switch to list_for_each_entry()
> itetators while I am at it.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
