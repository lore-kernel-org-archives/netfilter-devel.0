From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Build fixes for old Linuxes
Date: Fri, 18 Jan 2013 02:29:43 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1301180228250.14064@nerf07.vanv.qr>
References: <1358274002-6042-1-git-send-email-jengelh@inai.de> <20130118004455.GA20537@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ares07.inai.de ([5.9.24.206]:50289 "EHLO ares07.inai.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751296Ab3ARB3p (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Jan 2013 20:29:45 -0500
In-Reply-To: <20130118004455.GA20537@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


On Friday 2013-01-18 01:44, Pablo Neira Ayuso wrote:
>On Tue, Jan 15, 2013 at 07:20:00PM +0100, Jan Engelhardt wrote:
>> 
>> With this, iptables-1.4.17a (current git state) is tested to compile
>> and, to the degree covered by this patchset, to function under
>> Linux 2.4.27/glibc-2.3.2/Debian-3.1.
>
>Helping users is a noble thing from your side. However, that glibc
>branch [1] and that debian release [2] are not maintained anymore.

I kinda thought so. Was fun to look at it though.

So, what is the minimum {kernel, userspace} configuration that
we should require from users and which to put into INSTALL?
Do we still care about 2.4.x?
