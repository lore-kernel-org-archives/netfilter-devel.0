From: Deti Fliegl <deti@fliegl.de>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Sat, 29 Oct 2005 17:34:28 +0200
Message-ID: <43639684.5030502@fliegl.de>
References: <4361EAAB.1090206@fliegl.de>	<4361F6DF.3050106@eurodev.net>	<43621028.40705@fliegl.de>	<43627A8F.9060307@eurodev.net>	<436281BB.2010100@fliegl.de>
	<436373E8.7040606@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <436373E8.7040606@eurodev.net>
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

Pablo Neira wrote:
> Could you give a try to the patch attached and tell me if it fixes the 
> problem as well?
Well - Houston, We Have a Problem :(

nfnl_parse_attr: deficit (4) len (0).


Program received signal SIGSEGV, Segmentation fault.
0x00002aaaab0f6aa5 in parse_protoinfo () from 
/usr/local/lib//libnetfilter_conntrack_tcp.so
(gdb) bt
#0  0x00002aaaab0f6aa5 in parse_protoinfo () from 
/usr/local/lib//libnetfilter_conntrack_tcp.so
#1  0x00002aaaaabc41dc in nfct_conntrack_netlink_handler (cth=0x586010, 
nlh=0x7fffffc42d00, arg=<value optimized out>) at 
libnetfilter_conntrack.c:384
#2  0x00002aaaaabc37f0 in callback_handler (nladdr=<value optimized 
out>, n=0x7fffffc42b98, arg=<value optimized out>) at 
libnetfilter_conntrack.c:65
#3  0x00002aaaaacc8702 in nfnl_listen (nfnlh=0x586010, 
handler=0x2aaaaabc37c0 <callback_handler>, jarg=0x586010) at 
libnfnetlink.c:349
#4  0x00002aaaaabc4f8c in __nfct_dump_conntrack_table (cth=0x586010, 
zero=<value optimized out>) at libnetfilter_conntrack.c:857
#5  0x0000000000403242 in main (argc=2, argv=0x7fffffc45028) at 
conntrack.c:913
