From: Deti Fliegl <deti@fliegl.de>
Subject: problem with conntrack utility and kernel 2.6.14
Date: Fri, 28 Oct 2005 11:08:59 +0200
Message-ID: <4361EAAB.1090206@fliegl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi there,

Reading /proc/net/ip_conntrack seems to lock the table as long as being 
read which causes delays and loss in network traffic. Now I'm trying to 
use the conntrack utility from the subversion repository to list the 
conntrack table. This in turn prints out some "Unknown Attribute 5" 
lines and what's even worse it runs very often into a segmentation fault at

recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000008}, 
msg_iov(1)=[{"\260\0\0\0\0\1\0\6\0\0\0\0\0\0\0\0\2\0\0\0004\0\2\200\24"..., 
8192}], msg_controllen=0, msg_flags=0}, 0) = 176
write(2, "nfnl_parse_attr: deficit (4) len"..., 39nfnl_parse_attr: 
deficit (4) len (0).

) = 39

Maybe I'm wrong but it seems to happen due to a race condition when 
conntracking entries are being updated by the kernel... (if you like to 
reproduce this: just keep a high bandwidth connection open where byte 
counters in the conntrack tavle have to be updated very often...)


Deti
