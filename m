From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: POM ip_conntrack-timeouts.patch fails
Date: 20 May 2003 18:17:50 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1053447469.17388.141.camel@tux.rsn.bth.se>
References: <3ECA42AB.1020303@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Eicke Friedrich <tady@gmx.net>
In-Reply-To: <3ECA42AB.1020303@gmx.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 2003-05-20 at 16:58, Eicke Friedrich wrote:
> Hi,
> 
> I'm trying to apply the ip_conntrack-timeouts.patch to my system. I 
> get the following error message when I choose t for test:
> 
> Testing patch extra/ip_conntrack-timeouts.patch...
> Failed to patch copy of /usr/src/linux
> 
> I already applied a couple of patches to this system (CONNMARK for 
> example) but this one refuses to work. It's the same for the 
> tcp-window-patch that also allows to change the timeout values. Same 
> error message.
> 
> The system:
> Dual Athlon MP
> Kernel 2.4.20-SMP-4GB

Is this vanilla 2.4.20 or a vendor kernel?
p-o-m only supports vanilla kernels, but you might get lucky with a
vendor kernel.

> iptables 1.2.8
> patch-o-matic-20030107

use never p-o-m, either a snapshot or from cvs.

-- 
/Martin
