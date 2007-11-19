From: Phil Oester <kernel@linuxace.com>
Subject: Re: [RFC] Per-conntrack timeout target
Date: Sun, 18 Nov 2007 17:40:49 -0800
Message-ID: <20071119014049.GA2013@linuxace.com>
References: <20071117181123.GA15156@linuxace.com> <473F457C.1000708@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from adsl-67-120-171-161.dsl.lsan03.pacbell.net ([67.120.171.161]:46288
	"HELO linuxace.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751989AbXKSBkw (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 18 Nov 2007 20:40:52 -0500
Content-Disposition: inline
In-Reply-To: <473F457C.1000708@trash.net>
Sender: netfilter-devel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, Nov 17, 2007 at 08:48:12PM +0100, Patrick McHardy wrote:
> The only downside I see is that it adds another 4 bytes to the conntrack
> structure and distributions are probably going to enable it, like
> everything else. 

Yep, that's a problem.

> It would be nice if we could put this in a ct_extend
> structure, but that would mean you're only able to set it for new
> connections. What do you think about this?

Complicates my life, but is the Right Thing.  I'll work on this.
Should we be considering the same for mark/secmark?

Phil
