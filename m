From: Marcel Pol <mpol@gmx.net>
Subject: Re: linux-2.6 and iptables compiled against 2.4 problems
Date: Sat, 6 Sep 2003 17:30:36 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030906173036.4f471bf0.mpol@gmx.net>
References: <20030831150403.3472842d.mpol@gmx.net>
	<20030905115207.GB665@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20030905115207.GB665@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 5 Sep 2003 13:52:08 +0200
Harald Welte <laforge@netfilter.org> wrote:

> On Sun, Aug 31, 2003 at 03:04:03PM +0200, Marcel Pol wrote:
> > The problem is that when a distribution like Mandrake ships both a 2.4 and
> > a 2.6 kernel, it will have a broken iptables for linux-2.6. Linux-2.4 is
> > still the main kernel, and that's the one which is used to compile
> > iptables, while the latest 1.2.8 release doesn't compile against
> > linux-2.6.
> 
> 1.2.8 doesn't compile against 2.6 ? which 2.6 are you talking about?
> Why doesn't it compile?  What error messages do you get?

I'm compiling it against a 2.6-test4 kernelsource on mandrake cooker (9.2rc1)
with gcc-3.3.1 and glibc-2-3-2.

cc -O2 -Wall -Wunused -I/usr/src/linux/include -Iinclude/
-DIPTABLES_VERSION=\"1.2.8\"  -fPIC -o extensions/libipt_physdev_sh.o -c
extensions/libipt_physdev.c
extensions/libipt_physdev.c: In function `parse':
extensions/libipt_physdev.c:86: error: `IPT_PHYSDEV_OP_MATCH_IN' undeclared
(first use in this function)
extensions/libipt_physdev.c:86: error: (Each undeclared identifier is reported
only once
extensions/libipt_physdev.c:86: error: for each function it appears in.)
extensions/libipt_physdev.c:97: error: `IPT_PHYSDEV_OP_MATCH_OUT' undeclared
(first use in this function)
extensions/libipt_physdev.c: In function `print':
extensions/libipt_physdev.c:144: error: `IPT_PHYSDEV_OP_MATCH_IN' undeclared
(first use in this function)
extensions/libipt_physdev.c:146: error: `IPT_PHYSDEV_OP_MATCH_OUT' undeclared
(first use in this function)
extensions/libipt_physdev.c: In function `save':
extensions/libipt_physdev.c:156: error: `IPT_PHYSDEV_OP_MATCH_IN' undeclared
(first use in this function)
extensions/libipt_physdev.c:158: error: `IPT_PHYSDEV_OP_MATCH_OUT' undeclared
(first use in this function)
make: *** [extensions/libipt_physdev_sh.o] Error 1

 
> In any case the solution would be to release a new iptables (1.2.9)

If you do, would it be possible that if it's compiled against a 2.4 (2.4.22 or
newer) kernel, that it still works on a 2.6 (test4 or newer) kernel? I think
that's a bigger problem, because distro's will ship with two kernels, and
having one iptables package that works on both would be a good thing. Having
to ship two iptables packages will make it hard to get work right, and will be
confusing for users.


--
Marcel Pol
