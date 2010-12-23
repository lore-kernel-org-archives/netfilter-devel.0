From: David Miller <davem@davemloft.net>
Subject: Re: [ANNOUNCE] ipset-5.2 released
Date: Thu, 23 Dec 2010 11:32:26 -0800 (PST)
Message-ID: <20101223.113226.102539649.davem@davemloft.net>
References: <alpine.DEB.2.00.1012231553460.6044@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 74-93-104-97-Washington.hfc.comcastbusiness.net ([74.93.104.97]:57742
	"EHLO sunset.davemloft.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751213Ab0LWTb5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 23 Dec 2010 14:31:57 -0500
In-Reply-To: <alpine.DEB.2.00.1012231553460.6044@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Date: Thu, 23 Dec 2010 15:57:12 +0100 (CET)

>         git://git.netfilter.org/ipset.git, ipset-5 branch

This is way more difficult than it should be.

People cannot just clone your tree to look at the latest code.  The
master branch, which should be the latest and greatest, is your 4.x
stuff.

They have to go through a multi-step non-trivial process to get at the
latest 5.x code, and this is a serious discouragement.

It's frankly rediculious.

I personally did a "rm -rf ipset/" when I discovered how this was
setup, and I seriously wanted to review your code and look for bugs.
