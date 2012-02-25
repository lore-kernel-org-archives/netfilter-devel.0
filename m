From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: [RFC] SSDP (UPnP) conntrack helper
Date: Sat, 25 Feb 2012 13:07:28 -0600
Message-ID: <jibbhg$gu2$1@dough.gmane.org>
References: <jhkpju$dsp$1@dough.gmane.org> <20120224165359.GB11488@1984> <ji8r22$om2$1@dough.gmane.org> <20120225133229.GE15774@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:46007 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757546Ab2BYTHp (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 25 Feb 2012 14:07:45 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1S1My5-0003cP-JB
	for netfilter-devel@vger.kernel.org; Sat, 25 Feb 2012 20:07:41 +0100
Received: from pool-71-252-228-112.dllstx.fios.verizon.net ([71.252.228.112])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2012 20:07:41 +0100
Received: from arequipeno by pool-71-252-228-112.dllstx.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Sat, 25 Feb 2012 20:07:41 +0100
In-Reply-To: <20120225133229.GE15774@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/25/2012 07:32 AM, Pablo Neira Ayuso wrote:
> I'll be very happy if you work on the user-space version. The
> user-space cthelper infrastructure will be ready in two months
> or so.

I fully intend to, although I'll probably wait until the required
infrastructure makes it into Fedora.

> I think most of the questions can be replied by looking and
> nf_conntrack_expect.c. I'll try to find some spare time to reply some
> of those questions, but I don't promise anything.

I'll take another look at that file.  Many of my questions are of the
"why" variety, however, so looking at other files doesn't always help
that much.

I'm sure, BTW, that you're not the only person subscribed to this list
that has the knowledge to help out.  ;-)

Thanks!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
"If you're going to shift my paradigm ... at least buy me dinner first."
========================================================================

