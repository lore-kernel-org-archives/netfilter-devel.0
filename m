From: DarKRaveR <DarKRaveR@habitat-b.de>
Subject: Re: accounting
Date: Thu, 13 Feb 2003 01:02:12 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <17921743084.20030213010212@habitat-b.de>
References: <F14LEZF98vvwNeZsjSF0004b9b0@hotmail.com>
Reply-To: DarKRaveR <DarKRaveR@habitat-b.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Andrej Ricnik" <lemmetink@hotmail.com>
In-Reply-To: <F14LEZF98vvwNeZsjSF0004b9b0@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Andrej,

First of all: If you want a hardlimit, this is easy, there's an
extended match target, quota, which takes care of dropping a rule, as
soon, as the limit is hit.
So you can setup up rulkes for each ip, and make the rule basicly drop
....
And if there is no rule, you can set up one matching, since it has a
counter.

but, it is not too easy, to gather the information, you can either
iptables -L -v -x to grab the counters and parse the output ...
or use libiptc to do so ...

I kinda face the same problem here, just that I want the whole
enchilada database backed, and the rules should be generated from a
database with user information.
I am working on some c++ progs etc. to make a solution for our
scenario ... but it's all still earliest work in progress.

it's a pitty, I couldn'T find anythign usefull :-( could have save me
hours of work :-)

Thursday, February 13, 2003, 12:27:24 AM, you wrote:

AR> Hi Guys!

AR> I've been searching for a decent Linux IP accounting
AR> solution (I have a 5GB limit a month and don't want
AR> to pay a penalty just because the kids are greedy :})
AR> but couldn't find anything easy to use/decent that would
AR> allow me to keep track of traffic per IP and/or user
AR> and stop traffic from that IP/user once their "fair share"
AR> is used up ...

AR> So I was wondering how difficult it would be to intercept
AR> logging information from userland, and where to find
AR> info's on how to do it.



AR> Cheers,
AR> Tink

AR> -----BEGIN GEEK CODE BLOCK-----
AR> Version: 3.12
AR> GCM/IT/O d-(++)@ a C+(+++)@ UL++>+++ P+>+++ L++ E+@ W+@ N+ o? K? w---@(+) 
AR> O+++(+)@ M-@ V? PS+ PE- Y+ PGP++ t- 5- X- R-(*) tv-@ b+ DI++ D-- G++ !e* 
AR> h--- r++ z?
AR> ------END GEEK CODE BLOCK------



AR> _________________________________________________________________
AR> Tired of spam? Get advanced junk mail protection with MSN 8. 
AR> http://join.msn.com/?page=features/junkmail




-- 
Best regards,
 DarKRaveR                            mailto:DarKRaveR@habitat-b.de
