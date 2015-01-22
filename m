From: Patrick Schaaf <netdev@bof.de>
Subject: Re: Funny iptables -L output with 0.0.0.3 netmask
Date: Thu, 22 Jan 2015 14:21:02 +0100
Message-ID: <2006540.EBi7VRjMCC@rofl>
References: <5101724.aeQA8Siq95@rofl> <alpine.LSU.2.11.1501221301420.5184@nerf60.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 7Bit
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mars.intermailgate.com ([80.242.145.70]:49245 "EHLO
	mars.intermailgate.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751146AbbAVNVH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 Jan 2015 08:21:07 -0500
In-Reply-To: <alpine.LSU.2.11.1501221301420.5184@nerf60.vanv.qr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thursday 22 January 2015 13:31:33 Jan Engelhardt wrote:
> >ACCEPT     all  --  0.0.0.1/-1           anywhere
> >
> >Sorry if this is known + maybe already fixed in newer iptables versions...
> 
> commit 03e227017cca4f6d62a434bbaacf07e2869775b9
> Author: Phil Oester <kernel@linuxace.com>
> Date:   Thu Sep 26 09:06:58 2013 -0700
> 
>     libxtables: xtables_ipmask_to_numeric incorrect with non-CIDR masks
> 
> Wonder if it's really worth sending an update to 13.1.

Thanks, Jan!

I created https://bugzilla.opensuse.org/show_bug.cgi?id=914285 on the issue to 
let them decide :)

best regards
  Patrick
