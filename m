From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] multiple changes/fixes
Date: Sat, 28 Aug 2004 02:50:17 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408280248010.10624@filer.marasystems.com>
References: <20040827133700.GT23981@eychenne.org> <412F5A3C.1000704@trash.net>
	<20040827162808.GA29915@eychenne.org> <412F94D6.8040906@trash.net>
	<20040828000124.GB2416@eychenne.org>
	<Pine.LNX.4.61.0408280202470.10193@filer.marasystems.com>
	<20040828004039.GC2416@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20040828004039.GC2416@eychenne.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Sat, 28 Aug 2004, Herve Eychenne wrote:

> Yes... run indent on the current tree, run indent on the patched tree,
> and run diff on the two "indented" trees. But... too late: I took one
> hour to remove the fluff from my patch (sigh).

Found yet another useful tool for splitting patches with less 
dependencies: tkdiff

> I'll post 2 new patches tonight (if my head does not fall heavily on my
> keyboard til then): one containing the information, the other containing
> syntaxical or cosmetic changes, and typo fixes.

Great!

And thanks for encouraging me to look for tools doing this job easier. Was 
more things around than I expected to find.

Regards
Henrik
