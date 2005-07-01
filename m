From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: why spin_lock_bh() in match routine?
Date: Fri, 1 Jul 2005 19:33:32 -0400
Message-ID: <876ef97a0507011633c02bd9e@mail.gmail.com>
References: <Pine.LNX.4.62.0506301333510.2222@dgray-test.acs.internap.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Damon Gray <dgray@internap.com>
In-Reply-To: <Pine.LNX.4.62.0506301333510.2222@dgray-test.acs.internap.com>
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

On 6/30/05, Damon Gray <dgray@internap.com> wrote:=20
> If I'm not mistaken, and I possibly am, the match section of a netfilter
> module is run in softirq context, and the same softirq (not tasklet) can
> run on a *different* CPU but not the same CPU twice. So why is it being
> suggested here that we need to disable bottom halves for match targets.
> Seems to me you will be safe with spin_lock() in match() and possibly nee=
d
> spin_lock_bh() in at least destroy() and maybe in checkentry(). Am I
> missing some?

You wouldn't need to disable BH's in the match() function itself, but
rather in other contexts where the protected data may be accessed.
This serves to prevent the softirq in the process of running the
match() function, from pre-empting another context and deadlocking by
attempting to acquire a lock that is already held.

An example of this kind of mistake would be to use
spin_lock()/unlock() in the match() function to access/modify a
variable x and to ALSO use spin_lock()/unlock() (i.e. NOT disabling
BH's) in a proc file read function to access the same variable x. A
softirq could preempt the proc read function after the lock has been
acquired and cause a deadlock b/c the match() function would be unable
to acquire the lock held by the proc read function and the proc read
function is unable to return to the CPU because it was preempted by a
function that will never return.

--=20
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
