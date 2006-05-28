From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: netfilter support for entry data
Date: Mon, 29 May 2006 01:03:39 +0200
Message-ID: <200605290103.39778.max@nucleus.it>
References: <200605260019.16027.max@nucleus.it> <447705B9.4080809@trash.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <447705B9.4080809@trash.net>
Content-Disposition: inline
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

On Friday 26 May 2006 3:42 pm, Patrick McHardy wrote:

> Yes, sorry for not responding earlier.

Don't worry, I've been busy anyway.

> > We could minimize impact on the existing code introducing a "normal" and
> > an "extended" match funciton prototype, but this would crete complexity
> > and its only purpose is if we don't want to upgrade everything.
>
> Your goals are definitely worthwhile, but if we find a working solution
> we should just convert everything.

OK. In a few days I'll post a patch that adds the new functionality to the 
core of netfilter and another patch that upgrades all mainline matches.

If you like it, it will be easy to adapt all existing out of mainline matches. 
If this causes an uproar I can create a compatibility patch, but I wouldn't 
like it to be long lived.

> We try not to unreasonably reject good patches :) In this case however
> the patch breaks userspace compatibility (xt_entry_match is also used
> by userspace), so this isn't possible.

Ops... I didn't read much of the userspace code and didn't realize it. I would 
have realized it soon after starting, but you saved me time and trouble.

> Mhh .. thinking about it some more, we might be able to squeeze it
> into the u.kernel part, there should be enough room left in there.

You are right. We should have at least 20 bytes (depending on architecture) 
there. Putting important pointers in a union just to share a struct with 
userspace feels a bit weird, but is definitely feasible.
I'll follow your advice.

-- 
Bye,
   Massimiliano Hofer
