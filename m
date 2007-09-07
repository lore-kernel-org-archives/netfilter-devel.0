From: Steven Van Acker <deepstar+NRpGDEuW@singularity.be>
Subject: Re: [RFC] iptables namespaces
Date: Fri, 7 Sep 2007 19:06:01 +0000
Message-ID: <20070907190601.GA18714@ekonomika.be>
References: <20070907180204.GA460@ekonomika.be>
	<20070907184642.GA4728@outback.rfc2324.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <20070907184642.GA4728@outback.rfc2324.org>
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

On Fri, Sep 07, 2007 at 08:46:42PM +0200, Maximilian Wilhelm wrote:
> > The result is that for 1 minute, some traffic can get through the firewall rules
> > while other can not. We have had problems with spam getting through to 
> > mailservers behind the firewall, because not all firewall rules were loaded.
> 
> That problem can be solved.
> man iptables-restore

iptables-restore takes a file as input, not a series of iptables
commands. This means I would have to edit the file manually, not
something I want to do with 7000 firewall rules.

> > Using namespaces would make it possible to load all rules in another namespace
> > and when all rules are loaded, a switch can be toggled to switch over to the new
> > ruleset atomically.
> 
> That would be most probably nothing different to a iptables-restore.
> If you want to emulate that, load your 7000 iptables rules on a
> temp-machine, use iptables-save, copy the file to your firewalls and run
> iptables-restore

That looks somewhat complicated to me. Loading the rules on another
machine, with the only purpose to generate an iptables-restore file,
then copying that to the real firewall and loading it there.

iptables-restore can indeed be a solution, but then only if iptables can
use it as a staging area. That way you can tweak the firewall config
with the iptables command untill it fits your needs, before sending the
entire file to kernelspace with iptables-restore.

Also, this assumes that nothing will go wrong when entering the
firewall rules into kernel space, which means userspace and kernelspace
need to be in synch module-wise

kind regards,
-- Steven
