From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Iptables help
Date: Mon, 4 Apr 2005 16:46:15 +0200 (CEST)
Message-ID: <Pine.LNX.4.61.0504041630140.32358@filer.marasystems.com>
References: <200504031850.AAA18026@WS0005.indiatimes.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: dpadalkar2001 <dpadalkar2001@indiatimes.com>
In-Reply-To: <200504031850.AAA18026@WS0005.indiatimes.com>
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

On Mon, 4 Apr 2005, dpadalkar2001 wrote:

>    Currently i'm developing something similar to iptables.I wud like to know
> where does the iptables store the rules and the format in which it sotres the
> rules.

iptables stores rules in a linear table (with jumps), uploaded to the 
kernel as a binary blob. There is one such blob per table type (filter, 
nat, mangle, ...), and each hook has it's own entrypoint in the table.

This structure is managed by libiptc. Relevant structures can be found in 
include/linux/netfilter_ipv4/ip_tables.h. The main binary table descriptor 
is ipt_replace, and is immediately followed by a list of ipt_entry, each 
followed by a list of ipt_match and a final ipt_target.

I do not remember what the underflow thing is about.

> If i can know this , my task to store it in good format becomes a bit
> easier and more standardised . I shall be very grateful and am very very helpful

You may want to look at the HiPAC project

   http://www.hipac.org/

this uses very efficient tree structures for storing the ruleset.
