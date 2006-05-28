From: Torsten Luettgert <t.luettgert@pressestimmen.de>
Subject: Re: nth match
Date: Sun, 28 May 2006 02:13:50 +0200
Message-ID: <1148775230.9778.11.camel@murdegern.hindenburgdamm.example>
References: <1148743183.2259.8.camel@murdegern.hindenburgdamm.example>
	<447874D3.3030901@trash.net>
	<1148750003.2259.32.camel@murdegern.hindenburgdamm.example>
	<4478903A.3080402@trash.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4478903A.3080402@trash.net>
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

On Sat, 2006-05-27 at 19:45 +0200, Patrick McHardy wrote:
> Torsten Luettgert wrote:
> > On Sat, 2006-05-27 at 17:48 +0200, Patrick McHardy wrote:
> > 
> > Apparently you're seeing it more as a step stone on the way to
> > kernel inclusion. Now, it's you who are part of the team
> > and you're investing a lot of your own time for pom, not me,
> > so I'll just have to make do with what you're offering.
> 
> Actually I'm seeing it mostly as obsolete. Most of the patches
> still in there will get merged at some point. As for step stone,
> I think it many cases its counterproductive to put patches in
> there because they will bitrot, stop to apply and not get nearly
> as much testing as in the mainline kernel. Its usually even less
> work just doing the last bits I see necessary for kernel inclusion
> myself than apply to pom, wait, apply update, fix compilation,
> wait some more, ...

Hmm. So does this mean pom is (in)officially dead?
If new stuff doesn't go in there, and much of the old stuff is
removed, and the rest of it will be merged in the foreseeable future,
there's not much point in still maintaining it, right?

Personally, I'd regret that, because pom did at least supply
a fine framework for writing own matches and targets.

Regards,
Torsten
