From: Dan Kegel <dank@kegel.com>
Subject: Re: Building on case-insensitive filesystems
Date: Mon, 18 Oct 2004 08:28:36 -0700
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <4173E124.5040805@kegel.com>
References: <4171780F.1070909@kegel.com>
	<20041018134255.GG21927@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20041018134255.GG21927@sunbeam.de.gnumonks.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Harald Welte wrote:
>>Seems like ipt_mark_target.h might be a better name for
>>that latter file.  That would let developers who have
>>MacOSX or Windows laptops successfully unpack the
>>Linux source tree on their computers' case-insensitive filesystems.
> 
> 
> This has been discussed on the list before, the general result was IIRC
> that we don't really care, sorry.

Ah, well, crossdevelopers are used to encountering
indifference now and then from mainstream developers, so that's
not terribly surprising.

> Next time somebody comes along and says well, your more-than-8.3chars
> long filenames won't work on my DOS system.  

Let's see if we can distinguish between the two problems.  I know,
how 'bout this: it's reasonable to be expected to support
developer workstation filesystems which have a greater than 20% market share.
By that measure, it's reasonable to expect support for developing on
case-insensitive filesystems, but not on 8.3 char filesystems.
Hey, I did it!  (cue confetti)

> iptables fundamentally relies on the destinction:
> 
> lowercase == match module
> uppercase == target module
> 
> You can't just fix this by renaming kernel source files.
> 
> If I read your patch correctly, the resulting modules will have
> different names.  This will break auto-loading of match and target
> extensions, and it will break userspace compatibility with the userspace
> iptables program.
> 
> Also, the userspace iptables program has the same assumption, so without
> changing the whole chain
> 	- kernel file names
> 	- module autoloading
> 	- userspace filenames
> 	- userspace plugin autoloading
> it will not work.
> 
> Also, imagine what happens if someone tries to run an old userspace
> program and a new kernel or vice versa.  If we ever adopt a renaming
> scheme, it would have to work both forward and backwards compatible, we
> can't just change this within a stable kernel series.

Thanks for the summary of the technical issues.
I'm sure somebody sufficiently motivated could solve them
in a reasonable way.  I'll leave this for later -- I'm only
verifying gcc/glibc builds, so I don't need it -- but maybe
somebody else will come up with the right fix.

>>This is part of a larger effort to make life easier for
>>embedded Linux developers who are stuck developing on Windows
>>or Mac systems; see discussion at
> 
> You should actually start an opposite effort:  Make it harder for them,
> so it is enough pain to switch to a linux development system.  Please
> note, this is my personal opinion - not to be conflicted with the
> technical reasons given above.

Your helpful attitude is greatly appreciated.
- Dan

-- 
Trying to get a job as a c++ developer?  See http://kegel.com/academy/getting-hired.html
