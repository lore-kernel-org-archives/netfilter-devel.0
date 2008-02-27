From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 04/05]: nf_nat: always select same SNAT source for
 same host
Date: Wed, 27 Feb 2008 17:31:59 +0100
Message-ID: <47C5907F.3060904@trash.net>
References: <20080227131427.26831.51195.sendpatchset@localhost.localdomain> <20080227131432.26831.2125.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: davem@davemloft.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from viefep18-int.chello.at ([213.46.255.22]:31009 "EHLO
	viefep17-int.chello.at" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753241AbYB0QcO (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 27 Feb 2008 11:32:14 -0500
Received: from edge03 ([192.168.13.238]) by viefep17-int.chello.at
          (InterMail vM.7.08.02.00 201-2186-121-20061213) with ESMTP
          id <20080227163210.CNNV27032.viefep17-int.chello.at@edge03>
          for <netfilter-devel@vger.kernel.org>;
          Wed, 27 Feb 2008 17:32:10 +0100
In-Reply-To: <20080227131432.26831.2125.sendpatchset@localhost.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Patrick McHardy wrote:
> [NETFILTER]: nf_nat: always select same SNAT source for same host
> 
> We've removed the SAME target in 2.6.25-rc since it had 32/64 bit compat
> problems and the NAT core provides the same behaviour regarding IP
> selection. This turned out to be not entirely correct though, the
> NAT core only selects the same IP from a range for the same src,dst
> combination. Some people need the same IP for all destinations however.
> 
> The easiest way to do this is to ignore the destination IP when
> doing SNAT. Since we're using jhash, we still get good distribution
> for multiple source IPs.
> 
> Tested-by: David Lau <mintypickle@gmail.com>
> 
> Signed-off-by: Patrick McHardy <kaber@trash.net>


Please drop this patch for now, David reported some bad distribution
during further tests that I want to look into.

