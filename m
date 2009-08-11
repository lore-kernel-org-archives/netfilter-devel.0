From: Patrick McHardy <kaber@trash.net>
Subject: Re: codesize: netfilter/iptables vs. nftables
Date: Tue, 11 Aug 2009 15:53:19 +0200
Message-ID: <4A8177CF.6030708@trash.net>
References: <4A8146C4.5090108@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: "Christoph A." <casmls@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:33745 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754019AbZHKNxX (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 11 Aug 2009 09:53:23 -0400
In-Reply-To: <4A8146C4.5090108@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christoph A. wrote:
> Hi,
> 
> from my understanding of the initial announcement of nftables [1]
> 
> unlike the iptables kernel approach, nftables does not have a 1-to-1
> mapping of matches with modules in the kernel and provides only basic
> functionality/operations, userspace can use to combine to build
> matches/rules. (intelligence moves from kernel to userspace)
> 
> [1]
> http://thread.gmane.org/gmane.comp.security.firewalls.netfilter.devel/28922
> 
> When creating new matches/targets in iptables one must create the
> appropriate ipt/xt_<match> module for the kernel plus the userspace
> module  libipt/libxt_<match>.
> 
> With the generic way in which a nftables kernel handles data / provides
> functions I would assume that this approach of supporting new matches
> would change, and one must only create new combinations of kernel
> provided operations which does not require kernel code modifications.
> The kernelcode size of nftables would be constant regardless of how many
> matches it supports.
> Is this assumption correct?

It depends on the type of match. A new match of packet payload
for instance would likely not need any kernel changes. A new match
on data so far not supported at all would need changes to collect
that data. Once you are able to access a datum, you can combine it
with the existing features in any way you like, f.i. use for
comparisons, range comparisons, set lookups, maps, assignments, ...

> Another thing I would like to know is the current codesize of
> netfilter/iptables (including ip6tables and ebtables modules) compared
> to nftables kernelsize (sloc) (although the current featureset may defer)
> 
> 
> I compared them like this:
> 
> 1. step:
> count lines with sloccount in the following directories:
> net/ipv4/netfilter/
> net/ipv6/netfilter/
> net/bridge/netfilter/
> net/netfilter/
> 
> (gives me 802 files and 62462 SLOC)
> 
> 2. step:
> count lines in the same directories but only including files starting
> with nft_*
> 
> (62 files and 2288 SLOC)

That both seems wrong :) The diffstat of my nft-2.6 tree currently
shows:

 77 files changed, 7824 insertions(+), 258 deletions(-)

but some of that are just API changes touching other files. The
real code size currently is roughly 7300 lines I would guess, the
number of files is somewhere around 25.

> 3. step:
> subtraction:
> sloc_step1
> sloc_step2
> (62462 - 2288 = 60174)
> 
> netfilter/iptables: 60174 SLOC
> only nft_ files: 2288 SLOC
> (using nft-2.6 87f619abc27c38583abbf7268319c3f105bf09fd)
> 
> this is only correct if nftables does not depend on any code already
> present in non nft_* files and I guess this is not correct...(?)

Both use conntrack, NAT, the logging infrastructure and some more.
