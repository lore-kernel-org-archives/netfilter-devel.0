From: Phil Oester <kernel@linuxace.com>
Subject: Re: Trouble with PPTP
Date: Thu, 16 Oct 2003 09:06:18 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031016090618.A8133@ns1.theoesters.com>
References: <000c01c39322$c9fbcf40$01d2a8c0@adm.ae.wroc.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Andrzej Kozak <kozak@manager.ae.wroc.pl>
Content-Disposition: inline
In-Reply-To: <000c01c39322$c9fbcf40$01d2a8c0@adm.ae.wroc.pl>; from kozak@manager.ae.wroc.pl on Wed, Oct 15, 2003 at 03:46:49PM +0200
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Rebuild iptables userspace using the patched kernel for the headers.

Phil Oester

On Wed, Oct 15, 2003 at 03:46:49PM +0200, Andrzej Kozak wrote:
> Hello!
> When I patched my 2.4.22 kernel with pptp-conntrack-nat -DNAT and -SNAT is broken if I use iptables with -t nat
> I get message: iptables: Invalid argument
> Iptables v. 1.2.8
> I need establish connect from my security network to outside VPN server.
> 
> best regards
> 
> Andrew Kozak
