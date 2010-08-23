From: Peter Zijlstra <peterz@infradead.org>
Subject: Re: help needed with EXPORT_SYMBOL
Date: Mon, 23 Aug 2010 15:43:03 +0200
Message-ID: <1282570983.2605.1832.camel@laptop>
References: <1282373834.4080.79.camel@aijazbaig1-desktop>
	 <1282540448.4080.86.camel@aijazbaig1-desktop>
	 <AANLkTimtNOyJCbLxAW8Ebsftb58EWoNFW7Xkevqb6oGo@mail.gmail.com>
	 <1282569477.2605.1798.camel@laptop>
	 <alpine.LNX.2.01.1008231527390.21000@obet.zrqbmnf.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8BIT
Cc: Brian Gerst <brgerst@gmail.com>, aijazbaig1@gmail.com,
	netfilter-devel@vger.kernel.org, linux-kernel@vger.kernel.org
To: Jan Engelhardt <jengelh@medozas.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bombadil.infradead.org ([18.85.46.34]:51819 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752805Ab0HWNnF convert rfc822-to-8bit (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 23 Aug 2010 09:43:05 -0400
In-Reply-To: <alpine.LNX.2.01.1008231527390.21000@obet.zrqbmnf.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, 2010-08-23 at 15:32 +0200, Jan Engelhardt wrote:
> On Monday 2010-08-23 15:17, Peter Zijlstra wrote:
> 
> >On Mon, 2010-08-23 at 07:48 -0400, Brian Gerst wrote:
> >> 
> >> Use an exported function pointer in the main kernel as a hook that the
> >> module sets when it is loaded.  Note, you must use module_get and
> >> module_put around the call to the module to prevent it from unloading
> >> while in use. 
> >
> >Please don't do any such thing, its impossible to use correctly.
> >
> >Suppose there are two modular users, A and B.
> 
> Though in case there is just a single user it can work out.
> Just like bridge.c, and the bunch of nf_nat_*.c. :-)
> Though yeah. Bad bad.

We have this problem in several areas in the kernel (pm_idle being the
one I hate most since its in code I touch actually grew tons of users).

If you really need to export hooks, provide a registration mechanism and
an arbiter. A very simple, already existing, implementation of this
would be notification chains (include/linux/notifier.h), these provide a
registration interface, and the arbiter is a combination of static
priority combined with return codes.

A more complex example would be the cpuidle/pm_qos subsystem, where you
can register idle states and provide various attributes (exit latency,
energy break even duration, etc) and have the governor pick an idle
state depending on the predicted idle time and required exit latencies.

Bare function pointers suck.
