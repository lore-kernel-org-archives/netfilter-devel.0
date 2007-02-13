From: Max Kellermann <max@duempel.org>
Subject: Re: Bug: "You must specify `--icmpv6-type'"
Date: Tue, 13 Feb 2007 08:59:53 +0100
Message-ID: <20070213075953.GA6869@roonstrasse.net>
References: <20070209102829.GA31011@roonstrasse.net>
	<200702130301.l1D3159w015381@toshiba.co.jp>
	<200702130317.l1D3HZBT003648@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <200702130317.l1D3HZBT003648@toshiba.co.jp>
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

On 2007/02/13 04:17, Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp> wrote:
> I noticed libipt_icmp doesn't check no specified type, then applied
> following.

Makes sense, to get the parameter checks in sync.  However your
previous patch should also be applied, since it increases the
manpage's correctness.

Is there any disadvantage in loading protocol modules when none of
their checks is enabled?  Except maybe the CPU time spent in the
module callback.

Max
