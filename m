From: Pablo Neira <pablo@eurodev.net>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Fri, 28 Oct 2005 12:01:03 +0200
Message-ID: <4361F6DF.3050106@eurodev.net>
References: <4361EAAB.1090206@fliegl.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Deti Fliegl <deti@fliegl.de>
In-Reply-To: <4361EAAB.1090206@fliegl.de>
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

Deti Fliegl wrote:
> Reading /proc/net/ip_conntrack seems to lock the table as long as being 
> read which causes delays and loss in network traffic. Now I'm trying to 
> use the conntrack utility from the subversion repository to list the 
> conntrack table. This in turn prints out some "Unknown Attribute 5" 
> lines and what's even worse it runs very often into a segmentation fault at
> 
> recvmsg(3, {msg_name(12)={sa_family=AF_NETLINK, pid=0, groups=00000008}, 
> msg_iov(1)=[{"\260\0\0\0\0\1\0\6\0\0\0\0\0\0\0\0\2\0\0\0004\0\2\200\24"..., 
> 8192}], msg_controllen=0, msg_flags=0}, 0) = 176
> write(2, "nfnl_parse_attr: deficit (4) len"..., 39nfnl_parse_attr: 
> deficit (4) len (0).
> 
> ) = 39

This problem was already fixed days ago in libnetfilter_conntrack on Oct 
17, see SVN. I'm not able to reproduce what you're reporting. Please 
send me a gdb backtrace, together with other extra info. Are you running 
conntrack on a x86?

> Maybe I'm wrong but it seems to happen due to a race condition when 
> conntracking entries are being updated by the kernel... (if you like to 
> reproduce this: just keep a high bandwidth connection open where byte 
> counters in the conntrack tavle have to be updated very often...)

No, that doesn't make too much sense to me.

-- 
Pablo
