From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] multiple changes/fixes
Date: Sat, 28 Aug 2004 02:32:19 +0200 (CEST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <Pine.LNX.4.61.0408280202470.10193@filer.marasystems.com>
References: <20040827133700.GT23981@eychenne.org> <412F5A3C.1000704@trash.net>
	<20040827162808.GA29915@eychenne.org> <412F94D6.8040906@trash.net>
	<20040828000124.GB2416@eychenne.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20040828000124.GB2416@eychenne.org>
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

> BTW, I cannot imagine that an application enabling to wipe
> spacechanges-only from a patch does not currently exist... Eventually,
> it could wipe syntaxical changes only (but should be aware of the
> language structure/grammar), but that's harder, of course. So many
> things to do, and so little time...

The problem is most tools including patch & diff is line oriented, not 
whitespace oriented. It is trivial to weed out changes in indentation or 
whitespace per line only, but not changes involving reformatting such as 
moving the curly braket from one line to another etc.

To weed out the simple whitespace changes use "diff -wu"

Another tool which looks promising is xxdiff 
<url:http://xxdiff.sourceforge.net/>, but I have not been able to try this 
out yet.

> I don't think it's that hard. But I'm not objective, as I wrote it. :-)

I think it is very hard when I do the same thing which happens every now 
and then when restructuring a large piece of code, but that is me.

> The changes are simple, it's just that there are plenty of them.

Which makes the odd change which are different from the rest easy to miss.

>> with just one big patch that also reindents and reformats stuff.
>
> I know I'm a bad boy, but if I didn't do these as I was wandering
> through the code, I would never have done it afterwards, and I still
> think it was worth cleaning a little bit. Readability is often
> more important than one thinks.

There is several tools doing a very good job of cleaning up indentation 
and formatting. My favorite for C code is indent. There is no need of 
doing this by hand.

On the other hand the same tool can be used to identify the real changes 
"after the fact" even if the original code was a mess, simply by diffing 
the modified version with an original version formatted by the same tool.

Regards
Henrik
