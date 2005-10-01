From: Patrick McHardy <kaber@trash.net>
Subject: Re: 2.6.13-rc2+ - problem with DHCP
Date: Sat, 01 Oct 2005 19:58:26 +0200
Message-ID: <433ECE42.2070400@trash.net>
References: <433EBBEC.4050203@gorzow.mm.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Radoslaw Szkodzinski <astralstorm@gorzow.mm.pl>
In-Reply-To: <433EBBEC.4050203@gorzow.mm.pl>
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
> These kernels just do not get the IP from DHCP.
> I think the problem is caused by Mercurial tree changeset 8919 (more
> likely) or 8918.
> 
> At least the last tested working one is:
> changeset:   8917:07c96175a75e
> user:        Patrick McHardy <kaber@trash.net>
> date:        Tue Sep 13 21:00:14 2005 +0011
> summary:     [NETFILTER]: Simplify netbios helper
> 
> Probably the culprit is:
> changeset:   8919:61b9c3185973
> user:        Patrick McHardy <kaber@trash.net>
> date:        Tue Sep 13 21:00:55 2005 +0011
> summary:     [NETFILTER]: Fix DHCP + MASQUERADE problem

Are you sure? The patch was supposed to fix problems with DHCP clients
using regular UDP sockets for sending DHCP requests. Which client are
you using?
