From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: MASQUERADE: Route sent us somewhere else (was Re: Fw: Rusty's brain broke!)
Date: Wed, 14 Jan 2004 16:20:47 +1100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040114221944.AFA6B2C003@lists.samba.org>
References: <20040113115428.GO20206@sunbeam.de.gnumonks.org>
Cc: Patrick McHardy <kaber@trash.net>, kuznet@ms2.inr.ac.ru,
	fenio@o2.pl, davem@redhat.com, linux-net@vger.kernel.org,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	boris@boris.ca, email@cs-ware.de, Jan.Schubert@GMX.li
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-reply-to: Your message of "Tue, 13 Jan 2004 12:54:28 BST."
             <20040113115428.GO20206@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

In message <20040113115428.GO20206@sunbeam.de.gnumonks.org> you write:
> > Yes, this is the best.  It always does *something*, and is
> > predictable.  People with really complex routing shouldn't really use
> > MASQUERADE, since it's designed for a specific, simple case.
> 
> No, I really disagree with that.  I still don't understand what the
> problem was with the old solution.  We haven't received any complaints,
> at least not that I can remember.

I'm not so sure.  We know Patrick's solution will work.  Yes it might
break things.

> And as long as we don't provide a more sophisticated MASQUERADE
> replacement target, we shouldn't change the behaviour at all.
> 
> You cannot use SNAT for the dynamic IP address case, because it doesn't
> flush the tables.

We should probably do "-j SNAT --dynamic" for this case.

> And there are lots of users that have multiple DSL-dynip links these
> days, trying to statically or dynamically balance web requests between
> them, etc.

In that case, the interfaces are different, (ppp0 vs ppp1) so no
problem.  You need something more complex to trigger the problem
AFAICT.

Rusty.
--
  Anyone who quotes me in their sig is an idiot. -- Rusty Russell.
