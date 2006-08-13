From: Phil Oester <kernel@linuxace.com>
Subject: Re: connlimit
Date: Sun, 13 Aug 2006 16:40:53 -0700
Message-ID: <20060813234053.GA22015@linuxace.com>
References: <002d01c6bf2e$351f1c70$650ba8c0@DORKA>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org, ole@ans.pl
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: php0t <php0t@zorro.hu>
Content-Disposition: inline
In-Reply-To: <002d01c6bf2e$351f1c70$650ba8c0@DORKA>
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

On Mon, Aug 14, 2006 at 01:14:20AM +0200, php0t wrote:
> 
>   Dear developers,
> 
> I've had a nice time trying to limit connections. The kernel is
> 2.6.17.8.
> Apart from the first couple of annoyances (such as the patch being
> renamed from iplimit to connlimit, patch-o-matic not being able to apply
> it to the current kernel etc), I've managed to patch manually, compile
> it as a module and load it.
> 
>   However, when I try to add an according test rule, I get the 'Invalid
> argument' error, and dmesg says:
> ip_tables: connlimit match: invalid size 0 != 16

See this thread:

http://marc.theaimsgroup.com/?l=netfilter-devel&m=115334461228009&w=2

> When I google for my current problem, most suggest that connlimit is
> out-of-date, nobody cares about it any more, etc.

Next time try searching the netfilter archives directly.

Phil
