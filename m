From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: Re: [netfilter-core] ip_conntrack problems
Date: Mon, 17 Jan 2005 11:05:08 +0100 (CET)
Message-ID: <Pine.LNX.4.58.0501171100440.29249@tux.rsn.bth.se>
References: <200501142250.55955.gondim@intnet.com.br>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: coreteam@netfilter.org, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Marcelo Gondim <gondim@intnet.com.br>
In-Reply-To: <200501142250.55955.gondim@intnet.com.br>
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

On Fri, 14 Jan 2005, Marcelo Gondim wrote:

> Hi Core Team,

Hi, this mail should have been sent to the
netfilter-devel@lists.netfilter.org list.

> When our network is infected with any worm(netbios worm), as doing drop of
> package and using the kernel 2.6.10, this after some time (more or less one
> day), stop to send and receive packages and presents table errors conntrack
> full. I saw that as putting 65535 in ip_conntrack_max and when I alterate the
> timeouts it does not work.
>
> I returned to kernel 2.4, specifically the kernel 2.4.28 and the problems
> stopped. Does it exist any reason for that to happen?

This is a known bug which has been fixed. Either upgrade to 2.6.11-rc1 or
apply the patch at this location:
http://people.netfilter.org/gandalf/patches/conntrack-fix-rst.patch

Kernel 2.4.28 is known to have an ARP bug which can make it loose contact
with machines on the same subnet.

/Martin
