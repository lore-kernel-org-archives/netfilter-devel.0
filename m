From: Herve Eychenne <rv@wallfire.org>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Mon, 4 Jul 2005 13:21:05 +0200
Message-ID: <20050704112105.GD3331@eychenne.org>
References: <42C2C053.3040707@tac.ch> <20050629154049.GA17717@oknodo.bof.de>
	<20050629160923.GF3331@eychenne.org>
	<20050703123650.GW3186@sunbeam.de.gnumonks.org>
	<20050703220525.GA3331@eychenne.org>
	<20050704055541.GA29624@oknodo.bof.de>
	<42C8F151.9080708@tac.ch> <20050704100859.GC3331@eychenne.org>
	<42C91400.8000700@tac.ch>
Reply-To: Herve Eychenne <rv@wallfire.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
Content-Disposition: inline
In-Reply-To: <42C91400.8000700@tac.ch>
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

On Mon, Jul 04, 2005 at 12:48:32PM +0200, Roberto Nibali wrote:

> Fiddle around with the preprocessor in ipt_LOG.c and have yourself the value
> printed out using a new MODULE_PARM_DESC entry :)

That was what we were talking about earlier in this thread. Ok, but this
would then require some support/knowledge from userspace. I proposed /proc,
but Harald didn't seem very prone to use it. My question about the
reasons why is still unanswered.

> > Can you figure out that 90% of
> > Linux users in the world are meant to set up a firewall without even
> > knowing what a kernel is? ;-)

> Where do you have these numbers from? But this is besides the point. If so,
> those users will certainly not use iptables by hand, but a preconfigued script
> or even one of the nice GUIs for setting up the rules. The backend can handle
> such failures easily, no need to know the size :). And how many of those 90% do
> not use standard Linux distributions? Because I bet you 10 bucks that none of
> the well-known Linux Distributions is changing the ipt_log_info struct compared
> to plain vanilla sources.

Sorry, I thought the sententious tune and the smiley would have made this
affirmation appear as an impish kind-of-joke, or anyway one who didn't deserve
any rationnal answer (with which I can only agree though).

> > More seriously, I am reguarly asked to install a netfilter-based firewall
> > on machines I didn't install myself.

> > And most people are not even
> > aware there's a limit for LOG prefix length until they discover
> > the "too long (must be under xx chars)" message, believe me.

And it's the case for almost every static size...

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
