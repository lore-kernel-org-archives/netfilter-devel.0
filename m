From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH NF_CONNTRACK 0/8]: conflict symbols and getorigdst
	issue/bugs
Date: Sun, 17 Apr 2005 23:49:30 +0200
Message-ID: <4262D9EA.8010702@trash.net>
References: <200503221323.j2MDNfXS028596@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200503221323.j2MDNfXS028596@toshiba.co.jp>
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

Hi Yasuyuki,

Yasuyuki KOZAKAI wrote:

> These are patches for nf_conntrack which
> 	- unify common enums/flags in ip_conntrack and nf_conntrack,
> 	  as we talked,
> 	- fix other conflicts by changing he name of them in nf_conntrack,
> 	- change SO_ORIGINAL_DST to IPV6_ORIGINAL_DST in netfilter_ipv6.h
> 	  SO_* are socket level option names, not IP level. This doesn't
> 	  change netfilter_ipv4.h because of compatibility issue.
> 	- fix the bug which cannot find the target conntrack.
> 
> BTW, getorigdst() for IPv6 connection is really useful ? IPv6 connections
> are not NATed, then I think it's meaningless to call it.
> If it looks like it's useless, deleting it is fine with me.
> If not, please apply patches I send (08, 09).

sorry for takeing so long with this. I've applied patches 01-07 and
removed getorigdst(), thanks a lot.

Regards
Patrick
