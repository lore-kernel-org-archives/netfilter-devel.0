From: Jose Monteiro <jfmonteiro@netvisao.pt>
Subject: Re: ipt_limit module with sun4u architectures
Date: Thu, 19 Feb 2004 17:50:14 +0000
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040219175014.GA12545@primewebs.net>
References: <20040210184338.GA3237@primewebs.net> <20040214202227.GV7756@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
In-Reply-To: <20040214202227.GV7756@sunbeam.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sat, Feb 14, 2004 at 09:22:27PM +0100, Harald Welte wrote:
> I'm not aware of any possible workaround that would not make all 32bit
> architectures require to recompile their iptables userspace :(
> 
> https://bugzilla.netfilter.org/cgi-bin/bugzilla/show_bug.cgi?id=94

The thing is, old ultrasparcs can be reused as firewalls. But now, the os/software issue comes.

Suppose for instance, that management demands messenger audio/video through the firewall, even after being told about the riscs involved. sysadmins refuse to trade the existing sun4u/ipfilter solution for a m$ one, and they happen to have an unused ultrasparc.

porting intel's upnp sdk for solaris is out of the question, so other unix must be loaded. thinking of a *bsd is pointless because the existing ports of this sdk do not cleanly (if at all) compiles under a sun4u.

So we are left with the linux solution. debian's sparc port is ok, and upnpd/linux-igd compiles fine.

Now comes the iptables logging issue. If we log, the firewall is DoS'ed with a simple nmapping, so ipt_limit must be used, and because it cannot be used in 64bit/kernel 32bit/userland architectures, we are left with a perfectly running firewall but without any logging of its activity.

Since this bug is already very old (2003-05-29), and probably there aren't that few sun4u/linux/iptables users as it could be supposed (partly because of the line of reasoning above, who knows), i was coming for the help of you guys to see if a patch is made available.

Thx,
Jose
