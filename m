From: "He Ke" <heke@uestc.edu.cn>
Subject: a libipq problem(FAQ cannot help)
Date: Fri, 27 Aug 2004 18:01:08 +0800
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <293600868.26725@uestc.edu.cn>
Reply-To: He Ke <heke@uestc.edu.cn>
Content-Type: text/plain
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

i've now got a serious problem on the libipq programming.I wrote an application
which gets 
packets from iptables's QUEUE target(ip_queue&ip6_queue),and then deals with
them(drop,accept,...).
It works well with normal amout of packets,but when packets comes above 10M/s,it
dies soon,and show
 "Failed to received netlink message: No buffer space available".
   I've checked the FAQ,it says "you can tune their receive buffer sizes via
 /proc/sys/net/core, sysctl, or use the SO_RCVBUF socket option on the file
 descriptor".I tried them both , but it doesn't work,my application still die
soon
 when it meets packets above 10M/s.
   I tuned
  /proc/sys/net/core/rmem_default
  /proc/sys/net/core/rmem_max
 up to 1048576 .
   I modified the ipq_create_handle function in the libipq.c file, added the
 following sentence:
 	char maxbuf[1048576];
 	if(setsockopt(h->fd,SOL_SOCKET,SO_RCVBUF,&maxbuf,sizeof(maxbuf))==-1)
 		{
 		ipq_errno=IPQ_ERR_RECVBUF;
 		free(h);
 		return NULL;
 		}
 Am I right?
 If what i've done is what the FAQ says,why doesn't it work?
 the software snort_inline who uses this technique has the same problem,i've
 checked it.
 Would you please tell me how can i deal with this problem ?
 I'll be very appreaciate!
