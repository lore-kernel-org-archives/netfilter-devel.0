From: Pablo Neira Ayuso <pablo@eurodev.net>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Sun, 04 Dec 2005 03:14:34 +0100
Message-ID: <4392510A.3030400@eurodev.net>
References: <4361EAAB.1090206@fliegl.de>
	<4361F6DF.3050106@eurodev.net>	<43621028.40705@fliegl.de>
	<43627A8F.9060307@eurodev.net> <436281BB.2010100@fliegl.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------040702060702070006050603"
Cc: Deti Fliegl <deti@fliegl.de>, netfilter-devel@lists.netfilter.org,
	romary@nikoon.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <436281BB.2010100@fliegl.de>
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

This is a multi-part message in MIME format.
--------------040702060702070006050603
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit

Hi Patrick,

Deti Fliegl wrote:
> The kernel oops still happens - but this time I had access to the
> console (hope that helps):
> 
> <4>Badness in __kfree_skb at net/core/skbuff.c:330
> <4>
> <4>Call Trace:<ffffffff802a2f77>{__kfree_skb+167}
> <ffffffff802bb597>{netlink_recvmsg+279}
> <4>       <ffffffff8029cb2b>{sock_recvmsg+315}
> <ffffffff8025a4d8>{n_tty_receive_buf+4392}
> <4>       <ffffffff8025a4d8>{n_tty_receive_buf+4392}
> <ffffffff8015d828>{filemap_nopage+424}
> <4>       <ffffffff8013003b>{try_to_wake_up+1083}
> <ffffffff8014b2f0>{autoremove_wake_function+0}
> <4>       <ffffffff8025bbd9>{pty_write+89}
> <ffffffff8029e38b>{sys_recvmsg+395}
> <4>       <ffffffff80130f23>{__wake_up+67}
> <ffffffff80181208>{vfs_write+344}
> <4>       <ffffffff80181343>{sys_write+83}
> <ffffffff8010dc4e>{system_call+126}
> <4>
> <3>scheduling while atomic: conntrack/0xffffff00/7887

Romary Sonrier is reporting a similar problem on a i586 box:

https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=409

I can't see a way how the ctnetlink code can trigger that oops at moment
:(. Any clue on this?

-- 
Pablo

--------------040702060702070006050603
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

Dec  1 17:54:55 ipnobox_light_v1-8 Badness in __kfree_skb at net/core/skbuff.c:330
Dec  1 17:54:55 ipnobox_light_v1-8 [<c01ed857>] __kfree_skb+0x87/0xc0
Dec  1 17:54:55 ipnobox_light_v1-8 [<c0212048>] netlink_recvmsg+0xf8/0x220
Dec  1 17:54:55 ipnobox_light_v1-8 [<c01e98f6>] sock_recvmsg+0xe6/0x120
Dec  1 17:54:55 ipnobox_light_v1-8 [<c0126e0f>] file_read_actor+0x6f/0xe0
Dec  1 17:54:55 ipnobox_light_v1-8 [<c0120e90>] autoremove_wake_function+0x0/0x40
Dec  1 17:54:55 ipnobox_light_v1-8 [<c01eadb7>] sys_recvmsg+0xf7/0x1d0
Dec  1 17:54:55 ipnobox_light_v1-8 [<c012a490>] buffered_rmqueue+0xe0/0x1b0
Dec  1 17:54:55 ipnobox_light_v1-8 [<c0113eb2>] current_fs_time+0x42/0x50
Dec  1 17:54:55 ipnobox_light_v1-8 [<c0154343>] inode_update_time+0x33/0xa0
Dec  1 17:54:55 ipnobox_light_v1-8 [<c0147e34>] pipe_writev+0x324/0x4e0
Dec  1 17:54:55 ipnobox_light_v1-8 [<c0148017>] pipe_write+0x27/0x30
Dec  1 17:54:55 ipnobox_light_v1-8 [<c0180892>] copy_from_user+0x32/0x60
Dec  1 17:54:55 ipnobox_light_v1-8 [<c01eaefa>] sys_socketcall+0x6a/0x1e0
Dec  1 17:54:55 ipnobox_light_v1-8 [<c01028a9>] syscall_call+0x7/0xb
Dec  1 17:54:55 ipnobox_light_v1-8 scheduling while atomic:
conntrack/0xffffff00/1576
Dec  1 17:54:55 ipnobox_light_v1-8 [<c026b78d>] schedule+0x52d/0x5f0
Dec  1 17:54:55 ipnobox_light_v1-8 [<c01eaefa>] sys_socketcall+0x6a/0x1e0
Dec  1 17:54:55 ipnobox_light_v1-8 [<c010291a>] work_resched+0x5/0x16

>>uname -a
Linux ipnobox_light_v1-8 2.6.14.3 #1 Mon Nov 28 10:44:25 CET 2005 i586

--------------040702060702070006050603--
