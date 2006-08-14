From: Patrick McHardy <kaber@trash.net>
Subject: Re: priv_data patch
Date: Mon, 14 Aug 2006 17:05:07 +0200
Message-ID: <44E09123.9070508@trash.net>
References: <44E07BCD.8030206@trash.net>
	<200608141640.41759.max@nucleus.it>	<44E08D3B.7040505@trash.net>
	<20060814145801.GT7194@kriss.csbnet.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Massimiliano Hofer <max@nucleus.it>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Joakim Axelsson <gozem@gozem.se>
In-Reply-To: <20060814145801.GT7194@kriss.csbnet.se>
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

Joakim Axelsson wrote:
> 2006-08-14 16:48:27+0200, Patrick McHardy <kaber@trash.net> ->
> 
>>Its actually quite clear what is needed. We want a userspace interface
>>built on netlink, that acts on individual rules, not entire rulesets.
>>There are a few more ideas, like handling negation centrally, allowing
>>userspace to specify whether a target is terminal or not, allow multiple
>>non-terminal targets in a row, etc, but nothing really fundamental.
>>
> 
> 
> I have suggested this some years ago. But a new module type "action" could be
> used, along with "match" and "target". Meaning:
> 1. After zero, one or more matches
> 2. You run a zero, one or more actions
> 3. And finally end up in zero or one target.
> 
> Example:
> iptables -m condition -m limit -a LOG -j DROP 
> 
> This means that the only targets we have today (as i can remember now) are:
> -j ACCEPT
> -j DROP
> -j REJECT
> -j other_chain


Yes, we clearly want something like that. The exact details need to be
worked out when actually implementing it.
