From: Patrick Schaaf <bof@bof.de>
Subject: Re: PATCH: new match: userindex
Date: Wed, 8 Dec 2004 15:12:30 +0100
Message-ID: <20041208141230.GB20371@oknodo.bof.de>
References: <3801.217.169.232.210.1102511374.squirrel@hupie.xs4all.nl>
	<20041208131834.GA20371@oknodo.bof.de>
	<12701.217.169.232.210.1102514649.squirrel@hupie.xs4all.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Ferry Huberts <ferry@Hupie.com>
Content-Disposition: inline
In-Reply-To: <12701.217.169.232.210.1102514649.squirrel@hupie.xs4all.nl>
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

On Wed, Dec 08, 2004 at 03:04:09PM +0100, Ferry Huberts wrote:
> >> Kernel module for attaching a user specified index to a rule.
> >> It matches every packet in order to have no influence on packet
> >> matching,
> >> the only effect is to add a user index to a rule
> >
> > I think this is already covered - in extended form, i.e. arbitrary string
> > instead of an integer - by the comment match, found in patch-o-matic.
> 
> I know, but I needed a leaner module

Did you have performance / memory consumption issues with comment,
that you won't have with your new module?

> Also, using a number is much simpler, at least for me :-)

There's nothing stopping you from putting a number (ASCII formatted)
into the comment string. Per match, this will waste roughly NR_CPU*252 byte.

How many annotations do you need? Is your main memory really that constrained?

best regards
  Patrick
