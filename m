From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: Bug: "You must specify `--icmpv6-type'"
Date: Mon, 19 Feb 2007 13:11:28 +0900 (JST)
Message-ID: <200702190411.l1J4BTV3001831@toshiba.co.jp>
References: <200702130301.l1D3159w015381@toshiba.co.jp>
	<200702130317.l1D3HZBT003648@toshiba.co.jp>
	<20070213075953.GA6869@roonstrasse.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, yasuyuki.kozakai@toshiba.co.jp
To: max@duempel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070213075953.GA6869@roonstrasse.net>
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

From: Max Kellermann <max@duempel.org>
Date: Tue, 13 Feb 2007 08:59:53 +0100

> On 2007/02/13 04:17, Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp> wrote:
> > I noticed libipt_icmp doesn't check no specified type, then applied
> > following.
> 
> Makes sense, to get the parameter checks in sync.  However your
> previous patch should also be applied, since it increases the
> manpage's correctness.
> 
> Is there any disadvantage in loading protocol modules when none of
> their checks is enabled?  Except maybe the CPU time spent in the
> module callback.

Good question. Unlike libip6t_icmp6, libipt_icmp has the option which matches
all ICMP type. iptables passes it to kernel if user specify no option of
icmp match. Then that check is unneccesary. I forgot that.

I've reverted the previous commit and added comment. Thanks for notice.

-- Yasuyuki Kozakai
