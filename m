From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [RFC][PATCH] ctnetlink port to nf_conntrack take #3
Date: Thu, 15 Dec 2005 11:24:03 +0900 (JST)
Message-ID: <200512150224.jBF2O4lJ011204@toshiba.co.jp>
References: <439419A7.7040100@eurodev.net>
	<200512090241.jB92fXDR003303@toshiba.co.jp>
	<43A0C749.2050901@trash.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, pablo@eurodev.net,
	yasuyuki.kozakai@toshiba.co.jp
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <43A0C749.2050901@trash.net>
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

From: Patrick McHardy <kaber@trash.net>
Date: Thu, 15 Dec 2005 02:30:49 +0100

> Yasuyuki KOZAKAI wrote:
> >>Attached the 3rd incarnation of the ctnetlink port to nf_conntrack, it
> >>includes all recent Patrick's bugfixes and Yasuyuki's comments.
> >>
> >>nf_conntrack_netlink.c is available at:
> >>http://people.netfilter.org/pablo/nf_conntrack_netlink.c
> > 
> > Great work.
> > 
> > I have 2 more comments as follows. I'll send patches for them and
> > adding support for ICMPv6 in other mails.
> 
> Apart from these minor issues, I'm fine with the patch too.
> I'll apply it tommorrow if noone objects.

Well, I've found a issue. Current dumping code returns the informations about
IPv6 connections regardless of the address family in nfctnetlink header
(nfgenmsg). As a result, conntrack program prints "0.0.0.0 ....."

A something like filtering with address family might be necessary while
dumping. Yes, that would be inefficient. One long term solution would be
conntrack hash per layer 3 protocol.

The handling for other requests seem not to have this issue. Because they make
tuple which includes l3num and it is set to the address family in nfctnetlink
header. This means that just only requested layer 3 protocol for connection
can be handled.

-- Yasuyuki Kozakai
