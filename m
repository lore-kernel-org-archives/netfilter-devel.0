From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 00/13: netfilter update
Date: Tue, 08 Jul 2008 03:00:22 -0700 (PDT)
Message-ID: <20080708.030022.103062213.davem@davemloft.net>
References: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:36493
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1751076AbYGHKAW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 8 Jul 2008 06:00:22 -0400
In-Reply-To: <20080707120514.4975.88670.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Mon,  7 Jul 2008 14:05:15 +0200 (MEST)

> following is a small netfilter update for net-next-2.6, containing some
> minor cleanups and typo fixes, the case insensitive search support for the
> textsearch API and xtables string match from Joonwoo Park and some net-ns
> fixes from Alexey Dobriyan.

All applied, except patch 8 since it's in net-2.6 already, and
pushed back out to net-next-2.6

Thanks!
