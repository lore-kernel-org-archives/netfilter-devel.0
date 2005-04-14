From: Pablo Neira <pablo@eurodev.net>
Subject: Re: nfnetlink-ctnetlink working: INSTRUCTIONS
Date: Thu, 14 Apr 2005 11:40:10 +0200
Message-ID: <425E3A7A.90905@eurodev.net>
References: <425A5543.9000300@ufomechanic.net>
	<20050414162843.032A.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
In-Reply-To: <20050414162843.032A.LARK@linux.net.cn>
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

Wang Jian wrote:
> Hi Amin Azez,
> 
> The patch is not enough at least when compiled using gcc 3.4.
> 
> 
> [root@qos linux-2.6.11-w]# make O=/home/QoSTestBuild/ modules                     Using /home/linux-2.6.11-w as source for kernel
>   GEN    /home/QoSTestBuild/Makefile
>   CHK     include/linux/version.h
>   SPLIT   include/linux/autoconf.h -> include/config/*
> make[2]: `arch/i386/kernel/asm-offsets.s' is up to date.
>   CHK     include/asm-i386/asm_offsets.h
> gcc: drivers/atm/../../include/asm/byteorder.h: No such file or directory
> gcc: no input files
>   CC [M]  net/ipv4/netfilter/ip_conntrack_netlink.o
> /home/linux-2.6.11-w/net/ipv4/netfilter/ip_conntrack_netlink.c: In function `ctnetlink_create_conntrack':
> /home/linux-2.6.11-w/include/linux/netfilter_ipv4/ip_conntrack.h:344: sorry, unimplemented: inlining failed in call to 'ip_conntrack_free': function body not available
> /home/linux-2.6.11-w/net/ipv4/netfilter/ip_conntrack_netlink.c:652: sorry, unimplemented: called from here
> /home/linux-2.6.11-w/include/linux/netfilter_ipv4/ip_conntrack.h:346: sorry, unimplemented: inlining failed in call to 'ip_conntrack_insert': function body not available
> /home/linux-2.6.11-w/net/ipv4/netfilter/ip_conntrack_netlink.c:656: sorry, unimplemented: called from here
> make[4]: *** [net/ipv4/netfilter/ip_conntrack_netlink.o] Error 1
> make[3]: *** [net/ipv4/netfilter] Error 2
> make[2]: *** [net/ipv4] Error 2
> make[1]: *** [net] Error 2
> make: *** [modules] Error 2
> 
> and net/ipv4/netfilter/ip_conntrack_core.c has the same problem.

Just eemove `inline' from ip_conntrack_free and ip_conntrack_insert. 
I've just fixed those in the patches, so alternatively you could 
download the patch again. This seems to be something gcc-3.4 related 
since I didn't get such error with gcc-2.95.

--
Pablo
