From: Deti Fliegl <deti@fliegl.de>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Fri, 28 Oct 2005 21:53:31 +0200
Message-ID: <436281BB.2010100@fliegl.de>
References: <4361EAAB.1090206@fliegl.de>
	<4361F6DF.3050106@eurodev.net>	<43621028.40705@fliegl.de>
	<43627A8F.9060307@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <43627A8F.9060307@eurodev.net>
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
> Thanks for the very detailed report. The patch fixes some aligment 
> issues that I didn't handle properly :(. Please, give a try to the patch 
> attached and tell if it fixes your problem.
Thanks for the patch (which seemed to be already checked into svn) - 
conntrack now works properly - no seg faults occured :)

The kernel oops still happens - but this time I had access to the 
console (hope that helps):

<4>Badness in __kfree_skb at net/core/skbuff.c:330
<4>
<4>Call Trace:<ffffffff802a2f77>{__kfree_skb+167} 
<ffffffff802bb597>{netlink_recvmsg+279}
<4>       <ffffffff8029cb2b>{sock_recvmsg+315} 
<ffffffff8025a4d8>{n_tty_receive_buf+4392}
<4>       <ffffffff8025a4d8>{n_tty_receive_buf+4392} 
<ffffffff8015d828>{filemap_nopage+424}
<4>       <ffffffff8013003b>{try_to_wake_up+1083} 
<ffffffff8014b2f0>{autoremove_wake_function+0}
<4>       <ffffffff8025bbd9>{pty_write+89} 
<ffffffff8029e38b>{sys_recvmsg+395}
<4>       <ffffffff80130f23>{__wake_up+67} <ffffffff80181208>{vfs_write+344}
<4>       <ffffffff80181343>{sys_write+83} 
<ffffffff8010dc4e>{system_call+126}
<4>
<3>scheduling while atomic: conntrack/0xffffff00/7887
<4>
<4>Call Trace:<ffffffff8031d67d>{schedule+125} 
<ffffffff80181208>{vfs_write+344}
<4>       <ffffffff80181343>{sys_write+83} 
<ffffffff8010dcb8>{sysret_careful+13}
<4>
<4>Badness in __kfree_skb at net/core/skbuff.c:330
<4>
<4>Call Trace:<ffffffff802a2f77>{__kfree_skb+167} 
<ffffffff802bb597>{netlink_recvmsg+279}
<4>       <ffffffff8029cb2b>{sock_recvmsg+315} 
<ffffffff8025a4d8>{n_tty_receive_buf+4392}
<4>       <ffffffff8025a4d8>{n_tty_receive_buf+4392} 
<ffffffff8013578d>{printk+141}
<4>       <ffffffff8014b2f0>{autoremove_wake_function+0} 
<ffffffff8025bbd9>{pty_write+89}
<4>       <ffffffff8029e38b>{sys_recvmsg+395} 
<ffffffff8018e477>{pipe_writev+1319}
<4>       <ffffffff80181208>{vfs_write+344} <ffffffff80181343>{sys_write+83}
<4>       <ffffffff8010dc4e>{system_call+126}
<4>Badness in __kfree_skb at net/core/skbuff.c:330
<4>
<4>Call Trace:<ffffffff802a2f77>{__kfree_skb+167} 
<ffffffff802bb597>{netlink_recvmsg+279}
<4>       <ffffffff8029cb2b>{sock_recvmsg+315} 
<ffffffff8025a4d8>{n_tty_receive_buf+4392}
<4>       <ffffffff8025a4d8>{n_tty_receive_buf+4392} 
<ffffffff8013578d>{printk+141}
<4>       <ffffffff8014b2f0>{autoremove_wake_function+0} 
<ffffffff8025bbd9>{pty_write+89}
<4>       <ffffffff8029e38b>{sys_recvmsg+395} 
<ffffffff8018e477>{pipe_writev+1319}
<4>       <ffffffff80181208>{vfs_write+344} <ffffffff80181343>{sys_write+83}
<4>       <ffffffff8010dc4e>{system_call+126}

... etc...
