From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: TProxy w/2.6
Date: Wed, 23 Jun 2004 00:08:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40D8ADF1.8000400@balabit.hu>
References: <54933.68.92.26.41.1087835494.squirrel@mercury.ddos.com>    <20040621170452.GA6797@sch.bme.hu> <56384.68.92.26.41.1087931518.squirrel@mercury.ddos.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: evan@ddos.com
In-Reply-To: <56384.68.92.26.41.1087931518.squirrel@mercury.ddos.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


   Hi,

Evan Langlois wrote:
> tcp-window-tracking from pom applied to vanilla 2.6.6 - cttproxy patches
> from web site fails.  cttproxy applied to vanilla 2.6.6 fails.  I tried
> using other versions of the window tracking patch, they failed.
> 
> tcp-window-tracking applies fine.

   For me too, but I was unable to apply it onto 2.6.7.

> the tproxt in pom never works.  The cttproxy package does not apply to
> 2.6.6 even with tcp-window-tracking applied to a vanilla 2.6.6 kernel. 
> Are you using a vanilla kernel from kernel.org, or a kernel from some
> distribution that may have modified the original sources?

   I'm using vanilla sources, but the patch files are _generated_ partly 
using a simple shell script, partly using 'quilt'. The POM-ng port is 
not yet optimal, since it does not use .ladd files, so it's a bit picky 
regarding kernel versions.

> Note the very large number of failures!  This is against a vanilla 2.6.6
> kernel with the latest tcp-window-tracking patch from POMng applied (which
> applied cleanly).

$ wget http://www.balabit.com/downloads/tproxy/linux-2.4/devel/\
cttproxy-2.6.6-1.9.6.tar.gz
$ tar xzf cttproxy*.tar.gz
$ tar xjf linux-2.6.6.tar.bz2
$ cd linux-2.6.6
$ cat ../cttproxy-2.6.6-1.9.6/patch_tree/0{1,2,3}*.diff | patch -p1
patching file include/linux/netfilter_ipv4/ip_conntrack.h
Hunk #2 succeeded at 256 with fuzz 1 (offset -5 lines).
patching file include/linux/netfilter_ipv4/ip_nat.h
patching file net/ipv4/netfilter/ip_conntrack_core.c
Hunk #3 succeeded at 952 (offset -1 lines).
patching file net/ipv4/netfilter/ip_conntrack_standalone.c
Hunk #1 succeeded at 651 (offset -45 lines).
patching file net/ipv4/netfilter/ip_nat_core.c
patching file net/ipv4/netfilter/ip_nat_proto_icmp.c
patching file net/ipv4/netfilter/ip_nat_proto_tcp.c
patching file net/ipv4/netfilter/ip_nat_proto_udp.c
patching file net/ipv4/netfilter/ip_nat_standalone.c
patching file net/ipv4/netfilter/Kconfig
patching file net/ipv4/netfilter/ip_nat_standalone.c
patching file include/linux/in.h
patching file include/linux/net.h
patching file include/linux/netfilter_ipv4/ip_conntrack.h
Hunk #3 succeeded at 268 with fuzz 1 (offset -5 lines).
patching file include/linux/netfilter_ipv4/ip_nat.h
patching file include/linux/netfilter_ipv4/ip_nat_core.h
patching file include/linux/netfilter_ipv4/ip_tproxy.h
patching file include/linux/netfilter_ipv4/ipt_TPROXY.h
patching file include/net/ip.h
patching file net/ipv4/ip_sockglue.c
patching file net/ipv4/netfilter/Kconfig
patching file net/ipv4/netfilter/Makefile
patching file net/ipv4/netfilter/ip_conntrack_core.c
patching file net/ipv4/netfilter/ip_conntrack_standalone.c
Hunk #1 succeeded at 632 (offset -45 lines).
patching file net/ipv4/netfilter/ip_fw_compat_masq.c
patching file net/ipv4/netfilter/ip_nat_amanda.c
patching file net/ipv4/netfilter/ip_nat_core.c
patching file net/ipv4/netfilter/ip_nat_ftp.c
patching file net/ipv4/netfilter/ip_nat_irc.c
patching file net/ipv4/netfilter/ip_nat_rule.c
patching file net/ipv4/netfilter/ip_nat_standalone.c
patching file net/ipv4/netfilter/ip_nat_tftp.c
patching file net/ipv4/netfilter/ipt_MASQUERADE.c
patching file net/ipv4/netfilter/ipt_NETMAP.c
patching file net/ipv4/netfilter/ipt_REDIRECT.c
patching file net/ipv4/netfilter/ipt_SAME.c
patching file net/ipv4/netfilter/ipt_TPROXY.c
patching file net/ipv4/netfilter/ipt_tproxy.c
patching file net/ipv4/netfilter/iptable_tproxy.c
patching file net/ipv4/tcp_ipv4.c
patching file net/ipv4/udp.c
$

   So, I don't see any problems at all. Note that since I did not apply 
the window tracking patch, I skipped 04*.diff as well. Unfortunately I 
was unable to test POM-ng, since the POM-ng from CVS I've just checked 
out fails to apply tcp-window-tracking, because conntrack_error-api 
fails to apply. The approach you've tried is not correct, because the 
patches are dependant on each other, so applying 02-*.diff without 01... 
is not possible. And unfortunately running a simple patch with the 
'--dry-run' option does not know about this, and fails. POM-ng is wiser, 
and should correctly test dependant patchsets as well.

-- 
  Regards,
   Krisztian KOVACS
