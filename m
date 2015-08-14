From: Dave Jones <davej@codemonkey.org.uk>
Subject: Re: ipset triggering kasan warnings.
Date: Fri, 14 Aug 2015 09:51:15 -0400
Message-ID: <20150814135115.GA1843@codemonkey.org.uk>
References: <20150814011303.GB19621@codemonkey.org.uk>
 <alpine.DEB.2.10.1508141029360.28826@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from arcturus.aphlor.org ([188.246.204.175]:34828 "EHLO
	arcturus.aphlor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754304AbbHNNvW (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 14 Aug 2015 09:51:22 -0400
Content-Disposition: inline
In-Reply-To: <alpine.DEB.2.10.1508141029360.28826@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri, Aug 14, 2015 at 10:30:42AM +0200, Jozsef Kadlecsik wrote:
 > On Thu, 13 Aug 2015, Dave Jones wrote:
 > 
 > > I finally found some time to play with kasan, ad immediately hit some traces
 > > when I add a netmask with ipset.
 > 
 > Please let me know the kernel/ipset version.
 
Kernel is Linus' tree as of last night. so 4.2-rc6+

ipset version is..

$ ipset --version
ipset v6.23, protocol version: 6

as packaged by debian.

	Dave

