From: Patrick McHardy <kaber@trash.net>
Subject: Re: net/netfilter/nf_nat.h header instalation
Date: Fri, 29 Jul 2011 16:28:31 +0200
Message-ID: <4E32C38F.5070301@trash.net>
References: <1311932260.21981.11.camel@tablet>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Peter Volkov <pva@gentoo.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:56389 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282Ab1G2O2e (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 29 Jul 2011 10:28:34 -0400
In-Reply-To: <1311932260.21981.11.camel@tablet>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 29.07.2011 11:37, Peter Volkov wrote:
> Hi. Could you suggest solution for following problem:
> 
> miniupnpd [1] uses net/netfilter/nf_nat.h header and fails to build as
> normally this header is not installed by kernel during header. But is
> this correct?
> 
> As I found, iptables itself copies this kernel headers and bundles
> together with sources for reasons outlined in [3]. Now for miniupnpd
> distributions started to install  net/netfilter/*.h [4] [5]. I'm not
> opposed to install this headers in Gentoo too, bug if this is user space
> header shouldn't kernel install it?

iptables is actually wrong in copying that file, the userspace portions
such as nf_nat_manip_types and nf_nat_*range need to be moved to a new
file under include/linux/netfilter_ipv4/ which is installed and used
by userspace.
