From: Patrick McHardy <kaber@trash.net>
Subject: Re: nth match
Date: Sat, 27 May 2006 19:45:30 +0200
Message-ID: <4478903A.3080402@trash.net>
References: <1148743183.2259.8.camel@murdegern.hindenburgdamm.example>	
	<447874D3.3030901@trash.net>
	<1148750003.2259.32.camel@murdegern.hindenburgdamm.example>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
In-Reply-To: <1148750003.2259.32.camel@murdegern.hindenburgdamm.example>
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
> On Sat, 2006-05-27 at 17:48 +0200, Patrick McHardy wrote:
> 
>> nor is the
>>time undetermined, it will go in 2.6.18. In fact it is queued
>>for upstream submission sometime this weekend.
> 
> 
> That's good to hear. How about putting a patchlet dir into the
> repository? I could update my scripts that use nth to statistics
> once I see how it's used.

The removal was part of a large patch-o-matic cleanup to reduce
the overhead for us. Development today happens a lot nearer to
the kernel than it used to (which is good), so I don't think that
would do any good. I'll happily publish my git tree if anyone is
interested, but for 2.6.18 it doesn't really matter anymore since
I'm going to push out most of my patches this weekend.

>>I certainly won't let trivial patches bitrot in patch-o-matic.
>>Unlike the kernel, patch-o-matic never made any promises about backwards
>>compatibility, support or anything else.
> 
> 
> Oh, I never said you "must" do anything because you promised it
> or something. It's just that something I used and that works
> well just disappeared. Would it hurt so much to leave it in
> while it's still working until an alternative is available?

No, it wouldn't, but now its gone and we didn't even release the
stripped down pom yet, so I think people can just as well use the
last release.

> I always thought pom was an effort to bring useful functionality
> which didn't make the long, painful way into the official kernel
> (and probably never will) to simple users like me who can benefit
> from it, folks that don't have the time (or ability) to write it
> for themselves.
> 
> Apparently you're seeing it more as a step stone on the way to
> kernel inclusion. Now, it's you who are part of the team
> and you're investing a lot of your own time for pom, not me,
> so I'll just have to make do with what you're offering.

Actually I'm seeing it mostly as obsolete. Most of the patches
still in there will get merged at some point. As for step stone,
I think it many cases its counterproductive to put patches in
there because they will bitrot, stop to apply and not get nearly
as much testing as in the mainline kernel. Its usually even less
work just doing the last bits I see necessary for kernel inclusion
myself than apply to pom, wait, apply update, fix compilation,
wait some more, ...

>>You may also have noticed that it didn't even compile with current
>>kernels.
> 
> 
> Interesting. I just made a 2.6.16.18 with it, and it compiled
> just fine. Does it break on 2.6.17?

Yes. It also broke for 2.6.16, but was fixed.

> Sorry again, didn't mean to personally attack anyone.

Don't worry, no harm done.
