From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH] update raw patch in POM
Date: Tue, 07 Jun 2005 16:37:56 +0200
Message-ID: <42A5B144.3090005@tac.ch>
References: <42A57FC4.7010508@tac.ch>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developers <netfilter-devel@lists.netfilter.org>
In-Reply-To: <42A57FC4.7010508@tac.ch>
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

> This is the updated (rediffed) patch against 2.4.31 for the raw table feature.
> So far this has not been compile tested. Chunk #1 and #3 of the
> ip_conntrack_core.c part failed.

To avoid confusion: that was the reason I sent this patch. However when
compiling I get following error:

gcc -D__KERNEL__
-I/home/projects/pab2/src/share/kernel/2.4.x/linux-2.4.31-pab2/include -Wall
-Wstrict-prototypes -Wno-trigraphs -O2 -fno-strict-aliasing -fno-common
-fomit-frame-pointer -pipe -mpreferred-stack-boundary=2 -march=i686  -DMODULE
-DMODVERSIONS -include
/home/projects/pab2/src/share/kernel/2.4.x/linux-2.4.31-pab2/include/linux/modversions.h
 -nostdinc -iwithprefix include -DKBUILD_BASENAME=ip_conntrack_standalone
-DEXPORT_SYMTAB -c ip_conntrack_standalone.c
ip_conntrack_standalone.c: In function `ip_conntrack_defrag':
ip_conntrack_standalone.c:205: too few arguments to function
`ip_ct_gather_frags_Rsmp_0ed3e638'
ip_conntrack_standalone.c: At top level:
ip_conntrack_standalone.c:546: `ip_conntrack_untracked' undeclared here (not ina
function)
ip_conntrack_standalone.c:546: initializer element is not constant
ip_conntrack_standalone.c:546: (near initialization for
`__ksymtab_ip_conntrack_untracked.value')
make[3]: *** [ip_conntrack_standalone.o] Error 1
make[3]: Leaving directory
`/home/projects/pab2/src/share/kernel/2.4.x/linux-2.4.31-pab2/net/ipv4/netfilter'
make[2]: *** [_modsubdir_ipv4/netfilter] Error 2
make[2]: Leaving directory
`/home/projects/pab2/src/share/kernel/2.4.x/linux-2.4.31-pab2/net'
make[1]: *** [_mod_net] Error 2
make[1]: Leaving directory
`/home/projects/pab2/src/share/kernel/2.4.x/linux-2.4.31-pab2'
make: *** [compile] Error 2

Anyone?

Cheers,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Rathausgasse 31, CH-5001 Aarau  tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
