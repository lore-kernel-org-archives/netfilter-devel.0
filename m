From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables icmp protocol match bug.
Date: Fri, 1 Aug 2003 01:57:02 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0308010154490.21468-100000@filer.marasystems.com>
References: <3F299A94.5040003@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Peteris Krumins <newsgroups@lf.lv>, <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <3F299A94.5040003@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 1 Aug 2003, Patrick McHardy wrote:

> It is not defined. The highest defined type is ICMP_ADDRESSREPLY (18).
> Of course some application could construct _invalid_ icmp packets, but
> who cares ?

Anyone who wants to block such invalid ICMP packets.. but given the low 
ratio of valid ICMP codes it is easier to build a list of what one accepts 
than what not.

Regards
Henrik
