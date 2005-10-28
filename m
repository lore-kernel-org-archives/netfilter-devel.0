From: Deti Fliegl <deti@fliegl.de>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Fri, 28 Oct 2005 13:48:56 +0200
Message-ID: <43621028.40705@fliegl.de>
References: <4361EAAB.1090206@fliegl.de> <4361F6DF.3050106@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4361F6DF.3050106@eurodev.net>
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
> This problem was already fixed days ago in libnetfilter_conntrack on Oct 
> 17, see SVN. I'm not able to reproduce what you're reporting. Please 
What I'm doing is to request a file from a local webserver in an endless 
loop.

> send me a gdb backtrace, together with other extra info. Are you running 
> conntrack on a x86?
It's a x64_64 system.

Backtrace from gdb:

tcp      6 57 TIME_WAIT src=127.0.0.1 dst=127.0.0.1 sport=47582 dport=80 
packets=6 bytes=427 src=127.0.0.1 dst=127.0.0.1 sport=80 dport=47582 
packets=4 bytes=677 [ASSURED] mark=0 use=1
tcp      6 42 TIME_WAIT src=127.0.0.1 dst=127.0.0.1 sport=44717 dport=80 
packets=6 bytes=427 src=127.0.0.1 dst=127.0.0.1 sport=80 dport=44717 
packets=4 bytes=677 [ASSURED] mark=0 use=1
tcp      6 52 TIME_WAIT src=127.0.0.1 dst=127.0.0.1 sport=46652 dport=80 
packets=6 bytes=427 src=127.0.0.1 dst=127.0.0.1 sport=80 dport=46652 
packets=4 bytes=677 [ASSURED] mark=0 use=1
tcp      6 60 TIME_WAIT src=127.0.0.1 dst=127.0.0.1 sport=48037 dport=80 
packets=6 bytes=427 src=127.0.0.1 dst=127.0.0.1 sport=80 dport=48037 
packets=4 bytes=677 [ASSURED] mark=0 use=1
tcp      6 36 TIME_WAIT src=127.0.0.1 dst=127.0.0.1 sport=43471 dport=80 
packets=6 bytes=427 src=127.0.0.1 dst=127.0.0.1 sport=80 dport=43471 
packets=4 bytes=677 [ASSURED] mark=0 use=1
nfnl_parse_attr: deficit (4) len (0).


Program received signal SIGSEGV, Segmentation fault.
0x00002aaaab0f6aa5 in parse_protoinfo () from 
/usr/local/lib//libnetfilter_conntrack_tcp.so
(gdb) bt
#0  0x00002aaaab0f6aa5 in parse_protoinfo () from 
/usr/local/lib//libnetfilter_conntrack_tcp.so
#1  0x00002aaaaabc41dc in nfct_conntrack_netlink_handler (cth=0x586010, 
nlh=0x7fffff803760, arg=<value optimized out>) at 
libnetfilter_conntrack.c:376
#2  0x00002aaaaabc37f0 in callback_handler (nladdr=<value optimized 
out>, n=0x7fffff803608, arg=<value optimized out>) at 
libnetfilter_conntrack.c:57
#3  0x00002aaaaacc8702 in nfnl_listen (nfnlh=0x586010, 
handler=0x2aaaaabc37c0 <callback_handler>, jarg=0x586010) at 
libnfnetlink.c:349
#4  0x00002aaaaabc4f8c in __nfct_dump_conntrack_table (cth=0x586010, 
zero=<value optimized out>) at libnetfilter_conntrack.c:851
#5  0x0000000000403242 in main (argc=2, argv=0x7fffff805a48) at 
conntrack.c:913
(gdb)


Subversion Revision is 4394

All libn* directories were built using these commands:

aclocal && libtoolize -f && automake -a && autoconf (as my auto-tools 
are not named auto*-1.6 like autogen.sh wants it)

./configure
make clean all install

Files are from
2005-10-28 10:14 /usr/local/lib/libnetfilter_conntrack_icmp.so.0.0.0
2005-10-28 10:14 /usr/local/lib/libnetfilter_conntrack_sctp.so.0.0.0
2005-10-28 10:14 /usr/local/lib/libnetfilter_conntrack.so.0.0.0
2005-10-28 10:14 /usr/local/lib/libnetfilter_conntrack_tcp.so.0.0.0
2005-10-28 10:14 /usr/local/lib/libnetfilter_conntrack_udp.so.0.0.0
2005-10-28 10:15 /usr/local/lib/libnetfilter_log_libipulog.so.0.0.0
2005-10-28 10:15 /usr/local/lib/libnetfilter_log.so.0.0.0
2005-10-28 10:16 /usr/local/lib/libnetfilter_queue_libipq.so.0.0.0
2005-10-28 10:16 /usr/local/lib/libnetfilter_queue.so.0.0.0
2005-10-28 10:13 /usr/local/lib/libnfnetlink.so.0.0.0

Deti
