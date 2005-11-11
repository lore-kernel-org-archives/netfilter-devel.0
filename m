From: Deti Fliegl <deti@fliegl.de>
Subject: Re: again: conntrack & 2.6.14-git11
Date: Fri, 11 Nov 2005 08:10:53 +0100
Message-ID: <437443FD.1060604@fliegl.de>
References: <4371D660.4060003@fliegl.de> <4371FBDD.4020302@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4371FBDD.4020302@eurodev.net>
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
> I don't see the patch that is supposed to fix the problem in that git
> snapshot. Please, make sure that the patch attached is applied to your
> kernel tree.
Had a defective harddisk on my testsystem and was not able to test 
yesterday. Now I tried git13 which incorporates this patch but still got 
an oops. Not sure, if this is related to netlink/conntrack.

wget[4709]: segfault at 00002aab1313321d rip 00002aaaab21ba6f rsp 
00007fffffb61510 error 4
ACCEPT IN=mgmt OUT= MAC=00:04:23:b7:70:7c:00:d0:03:49:58:00:08:00 
SRC=10.156.10.105 DST=XX LEN=84 TOS=0x00 PREC=0x00 TTL=63 ID=2630 
PROTO=ICMP TYPE=0 CODE=0
  ID=55676 SEQ=1
Badness in __kfree_skb at net/core/skbuff.c:334

Call Trace:<ffffffff80271ab7>{__kfree_skb+165} 
<ffffffff80287fb5>{netlink_recvmsg+259}
        <ffffffff8026c14d>{sock_recvmsg+284} 
<ffffffff802e20eb>{thread_return+0}
        <ffffffff80151ca7>{file_read_actor+0} 
<ffffffff80143021>{autoremove_wake_function+0}
        <ffffffff8026d648>{sys_recvmsg+357} 
<ffffffff80143021>{autoremove_wake_function+0}
        <ffffffff8017c6d6>{pipe_writev+1293} 
<ffffffff80170cbe>{vfs_write+326}
        <ffffffff80170db2>{sys_write+69} <ffffffff8010d94e>{system_call+126}

Badness in __kfree_skb at net/core/skbuff.c:334

Call Trace:<ffffffff80271ab7>{__kfree_skb+165} 
<ffffffff80287fb5>{netlink_recvmsg+259}
        <ffffffff8026c14d>{sock_recvmsg+284} 
<ffffffff802e20eb>{thread_return+0}
        <ffffffff80151ca7>{file_read_actor+0} 
<ffffffff80143021>{autoremove_wake_function+0}
        <ffffffff8026d648>{sys_recvmsg+357} 
<ffffffff8017c6d6>{pipe_writev+1293}
        <ffffffff80170cbe>{vfs_write+326} <ffffffff80170db2>{sys_write+69}
        <ffffffff8010d94e>{system_call+126}
scheduling while atomic: conntrack/0xffffff00/15404

Call Trace:<ffffffff802e12af>{schedule+126} 
<ffffffff80170cbe>{vfs_write+326}
        <ffffffff80170db2>{sys_write+69} 
<ffffffff8010d9b8>{sysret_careful+13}

Further tried the refcount patch with 2.6.14 (no git version) without 
success (oops).
