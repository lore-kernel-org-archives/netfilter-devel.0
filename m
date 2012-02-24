From: Ian Pilcher <arequipeno@gmail.com>
Subject: Re: [RFC] SSDP (UPnP) conntrack helper
Date: Fri, 24 Feb 2012 14:13:54 -0600
Message-ID: <ji8r22$om2$1@dough.gmane.org>
References: <jhkpju$dsp$1@dough.gmane.org> <20120224165359.GB11488@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:52995 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755195Ab2BXUOG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 24 Feb 2012 15:14:06 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1S11Wl-0006GV-Hg
	for netfilter-devel@vger.kernel.org; Fri, 24 Feb 2012 21:14:03 +0100
Received: from pool-71-252-228-112.dllstx.fios.verizon.net ([71.252.228.112])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Feb 2012 21:14:03 +0100
Received: from arequipeno by pool-71-252-228-112.dllstx.fios.verizon.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Fri, 24 Feb 2012 21:14:03 +0100
In-Reply-To: <20120224165359.GB11488@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 02/24/2012 10:53 AM, Pablo Neira Ayuso wrote:
> We're targeting to have this helper and others in user-space in the
> short tun.
> 
> I have a patch to add user-space helper infrastructure. I expect to
> have it done soon.
> 
> I think it's time to think about having helpers in user-space.

Thanks for the response.

Assuming the user-space connection tracking thing pans out, it sounds
like there isn't much possibility of this making it upstream.

I'd still like to get it the module finished up.  It's a useful learning
exercise, and I think it could be useful for anyone who stays on an
older kernel, "enterprise" distribution users for example.

I would *really* appreciate some feedback on the various questions that
I've posed in this thread.

Thanks!

-- 
========================================================================
Ian Pilcher                                         arequipeno@gmail.com
"If you're going to shift my paradigm ... at least buy me dinner first."
========================================================================

