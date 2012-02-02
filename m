From: "U.Mutlu" <for-gmane@mutluit.com>
Subject: Re: libnetfilter_queue
Date: Thu, 02 Feb 2012 21:04:04 +0100
Message-ID: <4F2AEC34.1030203@mutluit.com>
References: <jgbnf5$id5$1@dough.gmane.org> <20120202183950.GA5268@1984>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from plane.gmane.org ([80.91.229.3]:56719 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756467Ab2BBUES (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Feb 2012 15:04:18 -0500
Received: from list by plane.gmane.org with local (Exim 4.69)
	(envelope-from <gnnd-netfilter-devel@m.gmane.org>)
	id 1Rt2tF-00052K-7j
	for netfilter-devel@vger.kernel.org; Thu, 02 Feb 2012 21:04:17 +0100
Received: from p4fe8b3b2.dip.t-dialin.net ([79.232.179.178])
        by main.gmane.org with esmtp (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Feb 2012 21:04:17 +0100
Received: from for-gmane by p4fe8b3b2.dip.t-dialin.net with local (Gmexim 0.1 (Debian))
        id 1AlnuQ-0007hv-00
        for <netfilter-devel@vger.kernel.org>; Thu, 02 Feb 2012 21:04:17 +0100
In-Reply-To: <20120202183950.GA5268@1984>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Pablo Neira Ayuso wrote, On 02/02/12 19:39:
> On Wed, Feb 01, 2012 at 04:58:29PM +0100, U.Mutlu wrote:
>> Hi,
>> who is the current maintainer of libnetfilter_queue?
>
> Me.

Oh thanks, I tried to use the demo in a virtual environment
under LXC and openvz (both actually chrooted environments)
but "something" seems to be missing as it doesn't work in
virtual environment, though it works in normal environment.
Exactly same problem happens with the netfilter demo in libmnl.

Here's the relevant strace-output (that's happening in the lib):
...
socket(PF_NETLINK, SOCK_RAW, 12)        = 5
getsockname(5, {sa_family=AF_NETLINK, pid=0, groups=00000000}, [12]) = 0
gettimeofday({1328152478, 343070}, NULL) = 0
bind(5, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = 0
getsockname(5, {sa_family=AF_NETLINK, pid=514, groups=00000000}, [12]) = 0
bind(5, {sa_family=AF_NETLINK, pid=514, groups=00000000}, 12) = 0
sendto(5, "\34\0\0\0\2\3\5\0\0\0\0\0\0\0\0\0\0\0\0\0\10\0\1\0\4\36\0\2", 28, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = -1 EC
sendto(5, "\34\0\0\0\2\3\5\0\0\0\0\0\0\0\0\0\0\0\0\0\10\0\1\0\3\36\0\2", 28, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = -1 EC
sendto(5, "\34\0\0\0\2\3\5\0\0\0\0\0\0\0\0\0\0\0\22h\10\0\1\0\1\0\0\0", 28, 0, {sa_family=AF_NETLINK, pid=0, groups=00000000}, 12) = -1 ECO
close(5)                                = 0
futex(0x1f96fc4, FUTEX_WAIT_PRIVATE, 1, NULL) = 0
futex(0x1f96f98, FUTEX_WAKE_PRIVATE, 1) = 0
...

So, sendto() to the netlink fails.
What's the reason, and what's needed to get the demo working?
Have you tested it in such virtual environments?

My guess:
I think it's a permission problem, but I don't know what kind of.
My guess is this: it runs under root account only, but the root
in the virtual environment is not the root in the normal environment,
each environment has its own root, and they differ. The uid, pid etc. in
the VM are just "translated" uid and pid I think, I think the problem lies herein.
I would appeciate it if it could be made to work also in VMs.

