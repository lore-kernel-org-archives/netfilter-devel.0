From: Patrick McHardy <kaber@trash.net>
Subject: Re: nth match
Date: Sat, 27 May 2006 17:48:35 +0200
Message-ID: <447874D3.3030901@trash.net>
References: <1148743183.2259.8.camel@murdegern.hindenburgdamm.example>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
In-Reply-To: <1148743183.2259.8.camel@murdegern.hindenburgdamm.example>
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

Torsten Luettgert wrote:
> Hello,
> 
> I understand Patrick wanted to integrate nth and random
> into a new statistics match. That's fine with me, but why
> was nth and random removed from pom without any replacement,
> i.e. the new statistics match?
> 
> You're just ripping out functionality based on something which
> will probably appear at some undetermined time in the future.

I did neither "rip something out", as the match was never part
of anything but a mostly random crap collection, nor is the
time undetermined, it will go in 2.6.18. In fact it is queued
for upstream submission sometime this weekend.

> That's no good style, sorry. Good style would be to first write
> the new match, adding it, giving it time to mature and marking
> the old stuff as obsolescent, then at some time removing it.

You're free to grab one of the many releases of patch-o-matic
that still contain the nth match and use that. I certainly
won't let trivial patches bitrot in patch-o-matic. Unlike the
kernel, patch-o-matic never made any promises about backwards
compatibility, support or anything else. You may also have
noticed that it didn't even compile with current kernels.

> (P.S.: sorry if this appears twice. I was so pissed off at the
> time that I forgot to use the correct sender address)

If you're so pissed off, how about you maintain a version until
2.6.18 is released? Feel free to set up a repository and send
me the URL to be included in the distibuted sources.list.
