From: Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: [PATCH 13/18] Netfilter: Multiport revision with port ranges
	(replaces "mport")
Date: Mon, 10 Jan 2005 13:24:11 +1100
Message-ID: <1105323851.22093.2.camel@localhost.localdomain>
References: <1104896159.20582.79.camel@localhost.localdomain>
	<20050105043027.GA23546@linuxace.com>
	<1104904015.20582.91.camel@localhost.localdomain>
	<20050108020322.GA11903@linuxace.com>
	<20050108034205.GK8756@eychenne.org> <41E1B162.2010104@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter development mailing list <netfilter-devel@lists.netfilter.org>,
	Herve Eychenne <rv@wallfire.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <41E1B162.2010104@eurodev.net>
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

On Sun, 2005-01-09 at 23:34 +0100, Pablo Neira wrote:
> bonjour,
> 
> Herve Eychenne wrote:
> 
> >>(note: didn't update manpage, but then again, wasn't updated with previous
> >>changes)
> >>    
> >>
> >
> >Maybe because no one stated what the manpage policy regarding the
> >new revision system would be?...
> >When adding every successive revision documentation of every
> >match/target to the manpage, wouldn't it become severly bloated in the
> >end?

You should add the new feature to the manpage.  The extension should
then fail with an appropriate message if the version of the kernel does
not support the option used.

eg. libipt_MARK.c's "parse_v0" accepts --and-mark (introduced in rev1)
like so:

	case '2':
		exit_error(PARAMETER_PROBLEM,
			   "MARK target: kernel too old for --and-mark");

Cheers,
Rusty.
-- 
A bad analogy is like a leaky screwdriver -- Richard Braakman
