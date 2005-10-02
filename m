From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.13-rc2+ - problem with DHCP
Date: Sun, 02 Oct 2005 07:28:19 +0200
Message-ID: <433F6FF3.1040706@trash.net>
References: <433EBBEC.4050203@gorzow.mm.pl> <433ECE42.2070400@trash.net>
	<433F0228.6000304@gorzow.mm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Radoslaw Szkodzinski <astralstorm@gorzow.mm.pl>
In-Reply-To: <433F0228.6000304@gorzow.mm.pl>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Radoslaw Szkodzinski wrote:
> -----BEGIN PGP SIGNED MESSAGE-----
> Hash: SHA1
> 
> Patrick McHardy wrote:
> |
> | Are you sure? The patch was supposed to fix problems with DHCP clients
> | using regular UDP sockets for sending DHCP requests. Which client are
> | you using?
> |
> 
> udhcpcd, version 0.9.9-pre (Gentoo ebuild
> net-misc/udhcp-0.9.9_pre20041216-r1, no crazy optimisations, stock init
> script, IP release disabled)

I can't reproduce the problem, it reliably works for me using pump,
dhclient or udhcpc. One thing I've noticed is that udhcpc 0.98
doesn't set the interface up itself and fails if it is down. Please
make sure that it is up in your tests.

> 2.6.13, 2.6.14-rc1 (up to the patch) both work fine.
> 2.6.14-rc2 and 2.6.14-rc3 do not. (they can't discover IP address)
> The window is between that commit and rc2.
> (about 180 changesets)
> 
> I only suspect that patch, it could be something else but I highly doubt
> it. I'll check the current kernel with the patch backed out when I have
> to restart.

Thanks. You mentioned you're setting up your ruleset after DHCP, which
means the patch can't be responsible because the codepath is never
taken for DHCP queries, so you probably need to do a binary search
over the remaining 180 changesets.
