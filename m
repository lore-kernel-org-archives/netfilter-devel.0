From: Deti Fliegl <deti@fliegl.de>
Subject: again: conntrack & 2.6.14-git11
Date: Wed, 09 Nov 2005 11:58:40 +0100
Message-ID: <4371D660.4060003@fliegl.de>
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

as far as I've seen all fixes for nf_netlink/conntrack are contained in 
2.6.14-git11. I tried calling conntrack within an endless loop while my 
stresstest was running. After app. 30 minutes the kernel crashed. Did I 
miss an important patch from this list? How can I help?

Deti
--
<4>Badness in __kfree_skb at net/core/skbuff.c:334
<4>
<4>Call Trace:<ffffffff802a3747>{__kfree_skb+167} 
<ffffffff802bbf17>{netlink_recvmsg+279}
<4>       <ffffffff8029d25b>{sock_recvmsg+315} 
<ffffffff80320583>{thread_return+0}
<4>       <ffffffff8015f2f3>{buffered_rmqueue+675} 
<ffffffff8012e245>{activate_task+149}
<4>       <ffffffff8012e69b>{try_to_wake_up+1083} 
<ffffffff80149210>{autoremove_wake_function+0}
<4>       <ffffffff8029eabb>{sys_recvmsg+395} 
<ffffffff8018c5d7>{pipe_writev+1319}
<4>       <ffffffff80320583>{thread_return+0} 
<ffffffff8017f4c8>{vfs_write+344}
<4>       <ffffffff8017f603>{sys_write+83} 
<ffffffff8010dc4e>{system_call+126}
