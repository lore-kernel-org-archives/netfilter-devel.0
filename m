From: "=?ISO-8859-2?Q?Stanis=B3aw_Pitucha?=" <viraptor@gmail.com>
Subject: ENOBUFS in nfq under heavy load
Date: Tue, 17 Jul 2007 16:46:16 +0100
Message-ID: <717e7cba0707170846k1856a1dbub59fc253dbaf070f@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Disposition: inline
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

Hi
After running nf_queue app under heavy load I get ENOBUFS error. Ok -
maybe not that heavy - around 100 concurrent voip calls - lots of
small udp packets. Nfq socket suddenly hangs. recv() from nfnl_fd()
socket returns -1, errno=ENOBUFS and when I try to destroy the queue
it stops:
stacktrace with gdb breaking...

#0  0xb7f38410 in __kernel_vsyscall ()
#1  0x4d23d0e1 in recvmsg () from /lib/libc.so.6
#2  0xb7f3185b in nfnl_talk (nfnlh=0x8061080, n=0xbfc9b5ec, peer=0,
groups=0, answer=0x0, junk=0, jarg=0x0)
    at ../../libnfnetlink-0.0.25/src/libnfnetlink.c:659
#3  0xb7f35055 in __build_send_cfg_msg (h=0x80611c0, command=<value
optimized out>, queuenum=<value optimized out>, pf=0)
    at ../../libnetfilter_queue-0.0.13/src/libnetfilter_queue.c:112
#4  0xb7f3511f in nfq_destroy_queue (qh=0x80611f8) at
../../libnetfilter_queue-0.0.13/src/libnetfilter_queue.c:258
#5  0x08049293 in main () at main.cc:287

Any idea how to avoid / fix it? Is the problem on my side?
My bufsize is 65535 for reading from nfq socket.

Thanks
Stan
