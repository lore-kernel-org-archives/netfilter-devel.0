From: William Stearns <wstearns@pobox.com>
Subject: Re: [PATCH] runme patch for 2.5
Date: Tue, 29 Oct 2002 11:37:46 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0210291133530.9352-100000@sparrow>
References: <Pine.LNX.4.44.0210131708170.15495-200000@sparrow>
Reply-To: William Stearns <wstearns@pobox.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
   Martin Josefsson <gandalf@wlug.westbo.se>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@gnumonks.org>
In-Reply-To: <Pine.LNX.4.44.0210131708170.15495-200000@sparrow>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Good day, all,

On Sun, 13 Oct 2002, William Stearns wrote:

> On 10 Oct 2002, Martin Josefsson wrote:
> 
> > Here's a small patch that will make patch-o-matic work with kernel 2.5
> > There's been some configurationchanges (Documentation/Configure.help
> > doesn't exist anymore)
> > 
> > This patch will make 'runme' incompatible with kernel 2.4 so use it only
> > with 2.5 kernels.
> 
> 	Many thanks, Martin, for the work.
> 	I've attached a patch, based on Martin's approach, that detects 
> whether Config.help or Configure.help is in use and automatically uses 
> what it finds.
> 	The second parameter to apply_config_help_change(s) has been 
> changed to the file to use rather than the directory in which Config*.help 
> lives.
> 	The patched runme successfully finds help files in 2.4.19 and 
> 2.5.42-ac1.  Please let me know if there are problems with it.

	Harald, do you have any concerns about the patch?  (Not resent in 
this mail, though I'd be happy to).
	Cheers,
	- Bill

---------------------------------------------------------------------------
	"1-800-psych: hello, welcome to the psychiatric hotline.  If you
are obsessive-compulsive, please press 1 repeatedly."
(Courtesy of Martin F Krafft <madduck@madduck.net>)
--------------------------------------------------------------------------
William Stearns (wstearns@pobox.com).  Mason, Buildkernel, named2hosts, 
and ipfwadm2ipchains are at:                        http://www.stearns.org
--------------------------------------------------------------------------
