From: Juan Carlos Castro y Castro <jcastro@vialink.com.br>
Subject: Error compiling ipt_osf.c and other weirdies (POM CVS)
Date: Fri, 03 Oct 2003 22:46:31 -0300
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F7E2677.7040606@vialink.com.br>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello and please CC me as I'm not on the list...

1) After applying patch-o-matic (CVS as of today) on a 2.4.23-pre6 
source tree (this happens also with 2.4.22-ac4), there's an error 
compiling ipt_osf. First it complains about an unterminated #ifdef in 
ipt_osf.h (trivial to correct). Added the missing #endif at the end, 
tried again and then it complains in ipt_osf.c itself. I had to 
unconfigure the OSF match in menuconfig. UPDATE: Jeez, it seems 
ipt_osf.c is truncated in the middle of a function!!! What gives?

gcc -D__KERNEL__ -I/usr/src/linux-2.4.23-pre6/include -Wall 
-Wstrict-prototypes
-Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -fomit-frame-pointer 
-pipe -mpreferred-stack-boundary=2 -march=athlon -DMODULE -DMODVERSIONS 
-include /usr/src/linux-2.4.23-pre6/include/linux/modversions.h  
-nostdinc -iwithprefix include -DKBUILD_BASENAME=ipt_osf  -c -o 
ipt_osf.o ipt_osf.c
ipt_osf.c:294: warning: function declaration isn't a prototype
ipt_osf.c: In function `osf_fini':
ipt_osf.c:686: parse error at end of input
ipt_osf.c:679: warning: unused variable `f'
ipt_osf.c:648: warning: `osf_init' defined but not used
ipt_osf.c:677: warning: `osf_fini' defined but not used
make[2]: ** [ipt_osf.o] Erro 1
make[2]: Saindo do diretório `/usr/src/linux-2.4.23-pre6/net/ipv4/netfilter'
make[1]: ** [_modsubdir_ipv4/netfilter] Erro 2
make[1]: Saindo do diretório `/usr/src/linux-2.4.23-pre6/net'
make: ** [_mod_net] Erro 2


2) I have to remove ULOG from extensions/Makefile when compiling 
userspace, else I get an error.

3) Also, there's lots of warnings like these during make modules:

gcc -D__KERNEL__ -I/usr/src/linux-2.4.23-pre6/include -Wall 
-Wstrict-prototypes
-Wno-trigraphs -O2 -fno-strict-aliasing -fno-common -fomit-frame-pointer 
-pipe -mpreferred-stack-boundary=2 -march=athlon -DMODULE -DMODVERSIONS 
-include /usr/src/linux-2.4.23-pre6/include/linux/modversions.h  
-nostdinc -iwithprefix include -DKBUILD_BASENAME=ip_nat_core  -c -o 
ip_nat_core.o ip_nat_core.c
In file included from 
/usr/src/linux-2.4.23-pre6/include/linux/netfilter_ipv4/ip_conntrack.h:66,
                 from ip_nat_core.c:21:
/usr/src/linux-2.4.23-pre6/include/linux/netfilter_ipv4/ip_conntrack_h323.h:7: 
warning: type defaults to `int' in declaration of `DECLARE_LOCK_EXTERN'
/usr/src/linux-2.4.23-pre6/include/linux/netfilter_ipv4/ip_conntrack_h323.h:7: 
warning: parameter names (without types) in function declaration
/usr/src/linux-2.4.23-pre6/include/linux/netfilter_ipv4/ip_conntrack_h323.h:7: 
warning: data definition has no type or storage class
