From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: what's the lockingrules for ip_conntrack_expect_list?
Date: 11 Oct 2002 15:56:13 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034344573.25146.55.camel@tux>
References: <Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.33.0210111455100.29766-100000@blackhole.kfki.hu>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 2002-10-11 at 15:06, Jozsef Kadlecsik wrote:
> Hi Martin,

Hi Jozsef,
 
> As far as I remember, the guiding rules were the following:
> ip_conntrack_lock is always held when we do something with the
> expectations. If it's write-locked, then there is no need for additional
> locking. If it's read-locked, then we use the additional
> ip_conntrack_expect_tuple_lock to protect the expectation lists.

Ahh that makes sense.
But is it really neccessary to hold ip_conntrack_lock when we are only
going to change an expectation and not touch anything else?
If we enforce that we always hold a readlock or writelock on
ip_conntrack_expect_tuple_lock when we touch it we should be safe?

I think Rusty has changed the lockingrules in his conntrack-optimization
patch to only require that we hold the ip_conntrack_expect_tuple_lock.

I'll look at Rusty's patch and make two versions of this fix, one for
current conntrack and one for his patch (if the bug exists there).

> > ip_conntrack_change_expect
> > 	MUST_BE_READ_LOCKED(&ip_conntrack_lock);
> > 	LIST_FIND
> >
> > 	FAILS!! called from nat-helpers which only hold their own locks 	if any
> > at all.
> 
> Well spotted! It's a locking bug then.

I just examined a bugreport :)

Thanks for the explanation.
 
-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
