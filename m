From: Feri adam <atash_000@yahoo.com>
Subject: help on string match
Date: Thu, 27 Jun 2002 15:55:54 -0700 (PDT)
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <20020627225554.25094.qmail@web20505.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

i get error in compile time 
....
here it is 



PLZ TELL ME WHAT SHOULD I DO THEN ?

make -C ipv4/netfilter modules
make[2]: Entering directory
`/root/linux/net/ipv4/netfilter'
gcc -D__KERNEL__ -I/root/linux/include -Wall
-Wstrict-prototypes -Wno-trigraphs -O2
-fomit-frame-pointer -fno-strict-aliasing -fno-common
-pipe -mpreferred-stack-boundary=2 -march=i686
-DMODULE -DMODVERSIONS -include
/root/linux/include/linux/modversions.h 
-DKBUILD_BASENAME=ipt_string  -c -o ipt_string.o
ipt_string.c
ipt_string.c:80:72: macro "max" passed 3 arguments,
but takes just 2
ipt_string.c: In function `search_sublinear':
ipt_string.c:53: warning: subscript has type `char'
ipt_string.c:78: warning: subscript has type `char'
ipt_string.c:80: `max' undeclared (first use in this
function)
ipt_string.c:80: (Each undeclared identifier is
reported only once
ipt_string.c:80: for each function it appears in.)
make[2]: *** [ipt_string.o] Error 1
make[2]: Leaving directory
`/root/linux/net/ipv4/netfilter'
make[1]: *** [_modsubdir_ipv4/netfilter] Error 2
make[1]: Leaving directory `/root/linux/net'
make: *** [_mod_net] Error 2


__________________________________________________
Do You Yahoo!?
Yahoo! - Official partner of 2002 FIFA World Cup
http://fifaworldcup.yahoo.com
