From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [PATCH] runme patch for 2.5
Date: 14 Oct 2002 15:30:29 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1034602229.7609.152.camel@tux>
References: <Pine.LNX.4.44.0210131708170.15495-200000@sparrow>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Harald Welte <laforge@gnumonks.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: William Stearns <wstearns@pobox.com>
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

On Sun, 2002-10-13 at 23:15, William Stearns wrote:
> Good evening, Martin, Harald, all,
> 
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

I think this looks ok but I havn't tested it yet. As long as p-o-m is
compatible with both 2.4 and 2.5 this would be a nice thing to include.
(and the same runme could be used for both 2.4 and 2.5 p-o-m when they
are split)

-- 
/Martin

Never argue with an idiot. They drag you down to their level, then beat
you with experience.
