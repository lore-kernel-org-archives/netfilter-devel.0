From: Vinay Reddy <vinayvinay@gmail.com>
Subject: Kernel panic due to local out handler calling itself again.
Date: Fri, 25 Feb 2005 16:14:32 +0530
Message-ID: <537f59d105022502444ad30394@mail.gmail.com>
Reply-To: Vinay Reddy <vinayvinay@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
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

Hi,
I am implementing a source routed protocol(like DSR) using netfilter
hooks. After rerouting the skb in my local_out handler, I return
NF_STOLEN and call the okfn (dst_output) directly. On testing the
code, we found that the local_out handler is being called, before the
previous call to local_out has returned. We were testing our protocol
by pinging.
In the first call of local_out, we get a normal echo packet(type 8),
but in the second call we get icmp packet types > 18 (NR_ICMP_TYPES).
We believe this caused the kernel panic that we observed. However, in
the oops trace the EIP value was 0x14000000, which we belive is not
pointing to our module. Infact in many of the dumps we observed, the
call trace did not contain any of our functions.
We are using the vanilla version of 2.6.10 kernel with
NF_DEBUG,KERNEL_DEBUG support enabled. Could this crash be due to the
fact that we are calling the okfn ourselves from local_out, which may
call a function thru the dst->output, which ultimately goes through
the LOCAL_OUT hook again, effectively we are somehow calling
ourselves.
But we are still not clear of the root of the problem we are facing.
We have been trying very hard to debug this problem, any help would be
greatly appreciated..

Thanks in advance.
Eagerly awaiting your reply.

Yours Sincerely,
Vinay Reddy.
