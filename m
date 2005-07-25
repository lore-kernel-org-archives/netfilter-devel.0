From: Robert de Bath <list-netfilter@debath.co.uk>
Subject: Re: expire module issue
Date: Mon, 25 Jul 2005 08:54:05 +0100 (BST)
Message-ID: <6e64e704791f94fb@mayday.cix.co.uk>
References: <20050706173023.GA3586@rover.pcbi.upenn.edu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bryan Cardillo <dillo@seas.upenn.edu>
In-Reply-To: <20050706173023.GA3586@rover.pcbi.upenn.edu>
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

On Wed, 6 Jul 2005, Bryan Cardillo wrote:

>        I'm having a problem with the expire module I submitted a
>        few days (weeks, maybe?) ago.  The observed behavior is that
>        expired rules cannot be deleted from built-in chains.  I
>        think the issue is related to deleting a rule (ipt_entry)
>        without fixing hook_entry / underflow to reflect the deleted
>        rule.
...
>        I've been using the iptables libiptc code as a guide for
>        implementing the rule deletion, but since this is strictly a
>        deletion, I'd rather not put the entire ruleset parsing and
>        compilation code in the kernel ;)  Any ideas how I can patch
>        up hook_entry / underflow appropriately?  Is this even the
>        problem?

Oh my, I've been just _looking_ at that library recently and I think this
way of modifing the tables is a very bad idea. IMO it's very similar to 
doing a binary patch on an executable, not something to be attempted in 
kernel space.

I would suggest you don't even try. :-)

Instead, how about leaving the rule behind in the table but when it
expires add an IPT_F_UNMATCHABLE flag to the rule (in ipt_entry.ip.flags)
The next time iptables is used to modify the table have _it_ skip the 
rule and delete it for you.

That should be the only cost and as a normal 'use case' would have new
rules being added steadly the undeleted expired rules would be purged
pretty quickly.

An advantage would be that until that next modify you could still see
the counters on expired rules. (Plus no fixups of course :)

PS: You won't lke this, but, it appears possible to have calls jumping
     to the middle of a chain. I'd guess that's what the 'high performance'
     rule generating programs do. This makes it _exactly_ like an
     executable; you can strip symbols too!

-- 
Rob.                          (Robert de Bath <robert$ @ debath.co.uk>)
                                              <http://www.debath.co.uk/>
