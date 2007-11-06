From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 01/07]: ip{,6}_queue: convert to seq_file interface
Date: Mon, 05 Nov 2007 20:35:11 -0800 (PST)
Message-ID: <20071105.203511.215776168.davem@davemloft.net>
References: <20071102112000.22803.92699.sendpatchset@localhost.localdomain>
	<20071102112001.22803.93793.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:42942
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1755528AbXKFEfM (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 5 Nov 2007 23:35:12 -0500
In-Reply-To: <20071102112001.22803.93793.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Patrick McHardy <kaber@trash.net>
Date: Fri,  2 Nov 2007 12:23:11 +0100 (MET)

> [NETFILTER]: ip{,6}_queue: convert to seq_file interface
> 
> I plan to kill ->get_info which means killing proc_net_create().
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@sw.ru>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
