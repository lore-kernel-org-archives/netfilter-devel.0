From: David Miller <davem@davemloft.net>
Subject: Re: netfilter 03/06: ip{,6}tables_security: fix future section
 mismatch
Date: Sat, 26 Jul 2008 17:48:45 -0700 (PDT)
Message-ID: <20080726.174845.217225114.davem@davemloft.net>
References: <20080726233705.15283.38364.sendpatchset@localhost.localdomain>
	<20080726233709.15283.65484.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:56279
	"EHLO sunset.davemloft.net" rhost-flags-OK-FAIL-OK-OK)
	by vger.kernel.org with ESMTP id S1756568AbYG0Asp (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 26 Jul 2008 20:48:45 -0400
In-Reply-To: <20080726233709.15283.65484.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Patrick McHardy <kaber@trash.net>
Date: Sun, 27 Jul 2008 01:37:10 +0200 (MEST)

> netfilter: ip{,6}tables_security: fix future section mismatch
> 
> Currently not visible, because NET_NS is mutually exclusive with SYSFS
> which is required by SECURITY.
> 
> Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
