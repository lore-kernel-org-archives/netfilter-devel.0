From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: Re: nth match
Date: Sat, 27 May 2006 19:13:23 +0200
Message-ID: <1148750003.2259.32.camel@murdegern.hindenburgdamm.example>
References: <1148743183.2259.8.camel@murdegern.hindenburgdamm.example>
	<447874D3.3030901@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <447874D3.3030901@trash.net>
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

On Sat, 2006-05-27 at 17:48 +0200, Patrick McHardy wrote:
> Torsten Luettgert wrote:
> > Hello,
> > 
> > You're just ripping out functionality based on something which
> > will probably appear at some undetermined time in the future.
> 
> I did neither "rip something out", as the match was never part
> of anything but a mostly random crap collection,

But you did, it's not in there any longer. Nevermind, I can
get it from old revisions.

>  nor is the
> time undetermined, it will go in 2.6.18. In fact it is queued
> for upstream submission sometime this weekend.

That's good to hear. How about putting a patchlet dir into the
repository? I could update my scripts that use nth to statistics
once I see how it's used.

> > That's no good style, sorry. Good style would be to first write
> > the new match, adding it, giving it time to mature and marking
> > the old stuff as obsolescent, then at some time removing it.
> 
> You're free to grab one of the many releases of patch-o-matic
> that still contain the nth match and use that.

Yep, just did that an hour ago.

> I certainly won't let trivial patches bitrot in patch-o-matic.
> Unlike the kernel, patch-o-matic never made any promises about backwards
> compatibility, support or anything else.

Oh, I never said you "must" do anything because you promised it
or something. It's just that something I used and that works
well just disappeared. Would it hurt so much to leave it in
while it's still working until an alternative is available?

I always thought pom was an effort to bring useful functionality
which didn't make the long, painful way into the official kernel
(and probably never will) to simple users like me who can benefit
from it, folks that don't have the time (or ability) to write it
for themselves.

Apparently you're seeing it more as a step stone on the way to
kernel inclusion. Now, it's you who are part of the team
and you're investing a lot of your own time for pom, not me,
so I'll just have to make do with what you're offering.

> You may also have noticed that it didn't even compile with current
> kernels.

Interesting. I just made a 2.6.16.18 with it, and it compiled
just fine. Does it break on 2.6.17?

> > (P.S.: sorry if this appears twice. I was so pissed off at the
> > time that I forgot to use the correct sender address)

Let me apologize for the tone of my original posting. I was
really running on adrenaline, since useful stuff was gone,
and stuff like rtsp-conntrack, which I have never seen even
compile, stays in just fine.

> If you're so pissed off, how about you maintain a version until
> 2.6.18 is released? Feel free to set up a repository and send
> me the URL to be included in the distibuted sources.list.

Personally, I'd like to do this. Unfortunately, I cannot, for
reasons I cannot go into at the moment. Nevermind, it has worked
for a long time (not counting the trivial changes in the .ladd files
when x_tables appeared), so it'll probably continue to do so
until your statistics match is available.

Sorry again, didn't mean to personally attack anyone.

Regards,
Torsten
