From: Leszek Zur <lzur@teczowe.eu.org>
Subject: Kernel 2.6.2 and "string" match patch (pom-ng)
Date: Tue, 10 Feb 2004 01:38:20 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <402827FC.2000209@teczowe.eu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

I can not get the string match patch to compile under 2.6.2

wget 
ftp://ftp.netfilter.org/pub/patch-o-matic-ng/snapshot/patch-o-matic-ng-20040207.tar.bz2
bzip2 -dc patch-o-matic-ng-20040207.tar.bz2 | tar xf -
cd patch-o-matic-ng-20040207
./runme string
...
Do you want to apply this patch [N/y/t/f/a/r/b/w/q/?] y
unable to find ladd slot in src ./net/ipv4/netfilter/Makefile

In
patch-o-matic-ng-20040207/string/linux/net/ipv4/netfilter/Makefile.ladd

obj-$(CONFIG_IP_NF_MATCH_UNCLEAN) += ipt_unclean.o
obj-$(CONFIG_IP_NF_MATCH_STRING) += ipt_string.o

But IP_NF_MATCH_UNCLEAN is not defined
When i change in patch-o-matic-ng-20040207/string/*
'UNCLEAN' to 'TOS'
'unclean' to 'tos'

./runme string

its ok.

cd /usr/src/linux
make bzImage
...
   CC      net/ipv4/netfilter/ipt_tos.o
   CC      net/ipv4/netfilter/ipt_string.o
net/ipv4/netfilter/ipt_string.c: In function `search_sublinear':
net/ipv4/netfilter/ipt_string.c:55: warning: subscript has type `char'
net/ipv4/netfilter/ipt_string.c:80: warning: subscript has type `char'
net/ipv4/netfilter/ipt_string.c: In function `string_freeup_data':
net/ipv4/netfilter/ipt_string.c:166: `smp_num_cpus' undeclared (first 
use in this function)
net/ipv4/netfilter/ipt_string.c:166: (Each undeclared identifier is 
reported only once
net/ipv4/netfilter/ipt_string.c:166: for each function it appears in.)
net/ipv4/netfilter/ipt_string.c: At top level:
net/ipv4/netfilter/ipt_string.c:176: warning: initialization from 
incompatible pointer type
net/ipv4/netfilter/ipt_string.c: In function `init':
net/ipv4/netfilter/ipt_string.c:184: `smp_num_cpus' undeclared (first 
use in this function)
make[3]: *** [net/ipv4/netfilter/ipt_string.o] Error 1
make[2]: *** [net/ipv4/netfilter] Error 2
make[1]: *** [net/ipv4] Error 2
make: *** [net] Error 2


has anybody been using the string match from the patch-o-matic-ng
with kernel 2.6.x yet?

Leszek
