From: Jan Engelhardt <jengelh@medozas.de>
Subject: Re: ipt_NETFLOW and xtables-addons
Date: Mon, 11 Apr 2011 04:37:36 +0200 (CEST)
Message-ID: <alpine.LNX.2.01.1104110434280.14676@obet.zrqbmnf.qr>
References: <4D4661F3.4070507@linux.vnet.ibm.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Srinivasa T N <seenutn@linux.vnet.ibm.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from borg.medozas.de ([188.40.89.202]:35187 "EHLO borg.medozas.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752138Ab1DKChi (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 10 Apr 2011 22:37:38 -0400
In-Reply-To: <4D4661F3.4070507@linux.vnet.ibm.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Monday 2011-01-31 08:17, Srinivasa T N wrote:

> Hi,
>   Can I compile ipt_NETFLOW standalone (i.e., use pom and not change kernel)?
> Or should I integrate that with xtables-addons?  If I have to integrate, how
> can I do so?

POM is defunct.

Integration into xtables-addons requires that the files be copied into 
it and the Kbuild, Mbuild, mconfig files be modified appropriately.

Most important of all is that the copy in xtables-addons should be a 
first-class citizen that is maintained, preferably by the person that 
does the current standalone releases. Me picking code updates from 
external projects would be time-consuming.
