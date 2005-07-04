From: Roberto Nibali <ratz@tac.ch>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Mon, 04 Jul 2005 12:48:32 +0200
Message-ID: <42C91400.8000700@tac.ch>
References: <42C2C053.3040707@tac.ch>
	<20050629154049.GA17717@oknodo.bof.de>	<20050629160923.GF3331@eychenne.org>	<20050703123650.GW3186@sunbeam.de.gnumonks.org>	<20050703220525.GA3331@eychenne.org>	<20050704055541.GA29624@oknodo.bof.de>
	<42C8F151.9080708@tac.ch> <20050704100859.GC3331@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: rv@eychenne.org
In-Reply-To: <20050704100859.GC3331@eychenne.org>
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

>>No, it's fix. And "probing" can easily be done with a large sized prefix,
>  
> As I said, if you want to know the exact value, you have to use an
> algorithm that tries to insert several LOG rules.
> If you want to provide here the best algorithm that does the least
> possible probes in the average case, you're welcome. ;-)

It's a matter either of the Pareto principle or if you prefer best practises.

> While this is an amusing exercise, I would prefer knowing the value
> directly. :-)

Fiddle around with the preprocessor in ipt_LOG.c and have yourself the value
printed out using a new MODULE_PARM_DESC entry :)

>>although I'm a bit astonished as to why someone wouldn't know the prefix size
>>when loading the packet filter ruleset.
>  
> This is a perfect kernel guy assertion. ;-)

No, a rather practical approach, as a matter of fact. See below.

> Can you figure out that 90% of
> Linux users in the world are meant to set up a firewall without even
> knowing what a kernel is? ;-)

Where do you have these numbers from? But this is besides the point. If so,
those users will certainly not use iptables by hand, but a preconfigued script
or even one of the nice GUIs for setting up the rules. The backend can handle
such failures easily, no need to know the size :). And how many of those 90% do
not use standard Linux distributions? Because I bet you 10 bucks that none of
the well-known Linux Distributions is changing the ipt_log_info struct compared
to plain vanilla sources.

> More seriously, I am reguarly asked to install a netfilter-based firewall
> on machines I didn't install myself. And most people are not even
> aware there's a limit for LOG prefix length until they discover
> the "too long (must be under xx chars)" message, believe me.

I believe you.

Best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
