From: Herve Eychenne <rv@wallfire.org>
Subject: Re: possible issues with blowing up struct ipt_log_info
Date: Mon, 4 Jul 2005 12:08:59 +0200
Message-ID: <20050704100859.GC3331@eychenne.org>
References: <42C2C053.3040707@tac.ch> <20050629154049.GA17717@oknodo.bof.de>
	<20050629160923.GF3331@eychenne.org>
	<20050703123650.GW3186@sunbeam.de.gnumonks.org>
	<20050703220525.GA3331@eychenne.org>
	<20050704055541.GA29624@oknodo.bof.de> <42C8F151.9080708@tac.ch>
Reply-To: rv@eychenne.org
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Developers <netfilter-devel@lists.netfilter.org>,
	Patrick Schaaf <bof@bof.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Roberto Nibali <ratz@tac.ch>
Content-Disposition: inline
In-Reply-To: <42C8F151.9080708@tac.ch>
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

On Mon, Jul 04, 2005 at 10:20:33AM +0200, Roberto Nibali wrote:

> >>Trying to insert potentially many LOG rules to empirically determine
> >>the maximum prefix length is far less complex, that's for sure. ;-)
> > 
> > Do we already have indeterminate log prefix length? I thought we had
> > one, fixed size, no probing neccessary. Am I wrong?

> No, it's fix. And "probing" can easily be done with a large sized prefix,

As I said, if you want to know the exact value, you have to use an
algorithm that tries to insert several LOG rules.
If you want to provide here the best algorithm that does the least
possible probes in the average case, you're welcome. ;-)

While this is an amusing exercise, I would prefer knowing the value
directly. :-)

> although I'm a bit astonished as to why someone wouldn't know the prefix size
> when loading the packet filter ruleset.

This is a perfect kernel guy assertion. ;-) Can you figure out that 90% of
Linux users in the world are meant to set up a firewall without even
knowing what a kernel is? ;-)
More seriously, I am reguarly asked to install a netfilter-based firewall
on machines I didn't install myself. And most people are not even
aware there's a limit for LOG prefix length until they discover
the "too long (must be under xx chars)" message, believe me.

 Herve

-- 
 _
(°=  Hervé Eychenne
//)
v_/_ WallFire project:  http://www.wallfire.org/
