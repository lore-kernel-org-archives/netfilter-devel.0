From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: memcmp() is slow?
Date: Sun, 23 Jan 2005 23:26:20 +0900 (JST)
Message-ID: <200501231426.j0NEQLW6019209@toshiba.co.jp>
References: <69935817.20050122213152@dns.toxicfilms.tv>
	<20050122195210.7c9b3d3f.davem@davemloft.net>
	<1583527289.20050123105709@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: yoshfuji@linux-ipv6.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: solt@dns.toxicfilms.tv
In-Reply-To: <1583527289.20050123105709@dns.toxicfilms.tv>
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


Hi,

From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Date: Sun, 23 Jan 2005 10:57:09 +0100

> Hello David,
> 
> Sunday, January 23, 2005, 4:52:10 AM, you wrote:
> 
> > This is a platform specific question, as memcmp() is implemented
> > differently on each architecture.  So tell us what you're test
> > was run on. :)
> 
> Well, it was yoshfuji's patch that suggested the change explaining
> that memcmp() is slow.
> 
> If joshfuji suggests a change like that, I think he is
> pretty sure that for all archs' memcmp() of 4 integers is slower
> than simply comparing them.

Yoshifuji and I think the reason is that memcmp() distinguishes 3 cases and
this code needs to distinguish only 2 cases (equal or not).

I run this code on Pentium M 1.1GHz. But I'm not sure it's true on
other archs. Should I revert it ?

-----------------------------------------------------------------
Yasuyuki KOZAKAI @ USAGI Project <yasuyuki.kozakai@toshiba.co.jp>
