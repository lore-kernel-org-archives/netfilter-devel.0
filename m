From: Phil Oester <kernel@linuxace.com>
Subject: Re: [PATCH] Pkttype match mismatches in OUTPUT chain
Date: Thu, 14 Aug 2008 05:02:40 -0700
Message-ID: <20080814120240.GA30222@linuxace.com>
References: <20080810221835.GA28761@linuxace.com> <20080810225353.GA31138@linuxace.com> <48A2E268.6010808@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:49237
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1753706AbYHNMCl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 14 Aug 2008 08:02:41 -0400
Content-Disposition: inline
In-Reply-To: <48A2E268.6010808@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Aug 13, 2008 at 03:32:24PM +0200, Patrick McHardy wrote:
> This is getting more and more kludgy, wouldn't it make more sense
> to move the pkt_type initialisation from the device layer to the
> protocol layer?

It would, but that's a large-ish change, and unknown if DaveM would
support it just to make an iptables match less kludgy.  

Unfortunately, it doesn't appear this match was tested very thoroughly
prior to being added to the tree...

Phil
