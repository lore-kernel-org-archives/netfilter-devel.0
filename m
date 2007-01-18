From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: PANIC: divide by zero in xt_connbytes
Date: Thu, 18 Jan 2007 15:22:37 +0100
Message-ID: <200701181522.37984@nienna>
References: <45AF5318.8040204@outerspace.dyndns.org>
	<45AF7617.8010202@netfilter.org>
	<45AF7861.5000201@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>, Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <45AF7861.5000201@outerspace.dyndns.org>
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


  Hi,

On Thursday 18 January 2007 14:38, Jonas Berlin wrote:
> | Better check that divisor must be != 0 inside div64_64.
>
> I initially suggested that too and would have renamed the function to
> div64_64_safe() or similar in the same go.. but Hidden (on irc) thought
> it was up to the caller to do the checking, and I felt he probably
> knows the kernel way of thinking better than me and succumbed. :) I
> think it's up to Patrick, I'm really only concerned with that it gets
> fixed :) If Patrick so requests, I'll redo it the other way..

  Not that it matters a lot, but I thought determining what to do if there 
have been no packets yet does not belong to the division routine 
logically. For me at least, it would introduce some kind of obscurity: at 
a first glance you won't be able to see what happens if packets==0, 
you'll have to scroll up to the div() function. Choosing zero as the 
average packet length in the corner case is appropriate only because 
that's whay usually makes sense in your ruleset. (For example if you use 
connbytes to classify traffic into bulk and interactive categories based 
on the average packet length, 0 as the "fallback" value is OK because it 
means that a brand new connection is considered interactive.)

  I guess this is a matter of personal preference: one way it's less code, 
the other way it's easier to read -- at least for me. Of course the only 
thing that matters is having this bug fixed, as it's quite ugly indeed.

-- 
 Regards,
  Krisztian Kovacs
