From: Lukas Ruf <ruf@rawip.org>
Subject: Re: iptables 1.2.11 and kernel 2.6.7
Date: Fri, 2 Jul 2004 16:22:00 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040702142200.GE11721@tik.ee.ethz.ch>
References: <20040702135147.GC11721@tik.ee.ethz.ch> <876ef97a04070207051e15f80a@mail.gmail.com>
Reply-To: PLEASE REPLY TO THE LIST <dev_null@rawip.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter development <netfilter-devel@lists.netfilter.org>
Content-Disposition: inline
In-Reply-To: <876ef97a04070207051e15f80a@mail.gmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

> Tobias DiPasquale <codeslinger@gmail.com> [2004-07-02 16:07]:
>
> On Fri, 2 Jul 2004 15:51:47 +0200, Lukas Ruf <ruf@rawip.org> wrote:
> > Has anyone experienced the same problems?  I could not find any answer
> > in the archive.
> >
> > If anyone would be interested in patch, please indicate and I will
> > create one.
>
> The patch in the following post fixes (at least) the DECLARE_MUTEX()
> problem for me. The issue was that the system headers were being used
> and not the headers in the kernel source tree:
>
> http://lists.netfilter.org/pipermail/netfilter/2004-June/053639.html
>
> However, the build process then fails during
> extensions/libipt_recent.c in the following manner:
>
> fearless:~/iptables-1.2.11> make KERNEL_DIR=/usr/src/linux
> Extensions found: IPv4:recent IPv6:ah IPv6:esp IPv6:frag
> IPv6:ipv6header IPv6:hbh IPv6:dst IPv6:rt
> gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
> -o extensions/libipt_ah_sh.o -c extensions/libipt_ah.c
> ld -shared  -o extensions/libipt_ah.so extensions/libipt_ah_sh.o
[...]
> gcc -O2 -Wall -Wunused -Iinclude/ -DIPTABLES_VERSION=\"1.2.11\"  -fPIC
> -o extensions/libipt_recent_sh.o -c extensions/libipt_recent.c
> extensions/libipt_recent.c:9:45: linux/netfilter_ipv4/ipt_recent.h: No
> such file or directory
> extensions/libipt_recent.c: In function `init':
> extensions/libipt_recent.c:77: error: dereferencing pointer to incomplete type
[...]
> make: *** [extensions/libipt_recent_sh.o] Error 1
> fearless:~/iptables-1.2.11>
>
> I am running on Gentoo Linux with a vanilla 2.6.7 kernel. I rebuilt
> the bzImage and modules in preparation for building iptables 1.2.11
> and they are in /usr/src/linux. Anyone have any ideas?
>
> P.S. Sorry if you feel I've hijacked your thread, but I think I'm
> pretty on-topic. If not, I can post again outside.
>

This is no problem.  It's pretty much the same problem, I presume.
So far, I have not made use of recent...

wbr,
Lukas
-- 
Lukas Ruf           | Wanna know anything about raw |
<http://www.lpr.ch> | IP? -> <http://www.rawip.org> |
eMail Style Guide: <http://www.rawip.org/style.html>|
