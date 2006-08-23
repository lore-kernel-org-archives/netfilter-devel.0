From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: new ABI
Date: Wed, 23 Aug 2006 23:19:21 +0200
Message-ID: <200608232319.22120.max@nucleus.it>
References: <200608142312.41851.max@nucleus.it>
	<200608160057.05431.max@nucleus.it> <44EC991F.7020909@anduras.de>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <44EC991F.7020909@anduras.de>
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

On Wednesday 23 August 2006 8:06 pm, Sven Anders wrote:

> > The real question thus becomes: is it worh to restart from (almost)
> > scratch?
>
> In my personal opinion it's time for a new API.
> During the implementation of my program, I run into many problems which
> could only be solved clearly by a new API. It would make the implementation
> of other user-space programs (beside iptables) much easier.

Do you mean ABI?

> I would love to have unique rule ids! 8-)

Would a number be sufficient, or do you think a user supplied string would be 
much more useful? Of course the kernel will assign default ids to id-less 
rules.

>    I think this could be done with little changes on the current netfilter
> core too, but it would be better to do it in a new framework. You only have
> to distinguish between VERIDICT and NON-VERDICT targets.

The current data structures will be completely wiped away. This isn't a little 
change and will need a lot of testing.

>   - A NOT for all matches

If we implement boolean expressions a NOT won't be the least bit difficult.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
