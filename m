From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: New draft document on nat / traversal / hole punching (with
	Dan Kegel)
Date: Thu, 18 Nov 2004 13:47:32 +1100
Message-ID: <1100746052.5865.17.camel@localhost.localdomain>
References: <20041109154946.GD22257@sunbeam.de.gnumonks.org>
	<200411161538.48528.baford@mit.edu>
	<1100663932.5176.48.camel@localhost.localdomain>
	<200411171133.27737.baford@mit.edu>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, srisures@yahoo.com,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Netfilter Core Team <coreteam@netfilter.org>, dank@kegel.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Bryan Ford <baford@mit.edu>
In-Reply-To: <200411171133.27737.baford@mit.edu>
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

On Wed, 2004-11-17 at 11:33 -0500, Bryan Ford wrote:
> > I hope that explains?  We're going to have to think hard about changing
> > to a port reservation architecture if we really want the hairpin
> > feature.
> 
> Yes, I agree - and I hope it's clear now that it's not just about the hairpin 
> feature, but about reliably supporting hole-punching in general, even in the 
> standard single-level NAT case.

One issue that became clear to me in developing and receiving bug
reports for NAT was that NAT is *always* a "90%" solution. ie. aim to be
best effort rather than reliable.  With unknown protocols,
fragmentation, embedded source addresses, address exhaustion, etc, we're
always imperfect.  Once I absorbed this epiphany this made my life was
much easier 8)

For the common, simple case, our current behaviour works (which is good,
because those machines will stay out there for a long time yet!).

But I think there's evidence here is that the balance is shifting: more
protocols are NAT-aware, and excellent (and hopefully to-be-widespread)
papers such as yours will hopefully accelerate this trend.  So we should
look to changing the implementation now, even if we risk becoming worse
in the short term.

Thanks,
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
