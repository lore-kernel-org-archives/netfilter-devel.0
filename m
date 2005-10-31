From: Deti Fliegl <deti@fliegl.de>
Subject: Re: Unknown Attribute 5/conntrack -L
Date: Mon, 31 Oct 2005 21:36:38 +0100
Message-ID: <43668056.8000400@fliegl.de>
References: <Pine.LNX.4.62.0510310846320.8000@bizon.gios.gov.pl>	<43662D1E.4000308@eurodev.net>	<Pine.LNX.4.62.0510311544350.31123@bizon.gios.gov.pl>
	<200510311902.j9VJ28fq026612@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: pablo@eurodev.net, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200510311902.j9VJ28fq026612@toshiba.co.jp>
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

Hi Yasuyuki,

> I'm not sure it's the reason of oops, but at least attached patch fixes
> double free after netlink_unicast(). Krzysztof, could you try this ?
Tried it with 2.6.14 - after 20 minutes of calling conntrack -L in an 
endless loop (with ~20000 entries and 800Mbit/s load) it happened again:

<4>Badness in __kfree_skb at net/core/skbuff.c:330
<4>
<4>Call Trace:<ffffffff802a2f77>{__kfree_skb+167} 
<ffffffff802bb597>{netlink_recvmsg+279}
<4>       <ffffffff8029cb2b>{sock_recvmsg+315} 
<ffffffff8019b457>{update_atime+151}
<4>       <ffffffff8015ddfa>{do_generic_mapping_read+1098} 
<ffffffff80161311>{buffered_rmqueue+529}
<4>       <ffffffff8012fbe5>{activate_task+149} 
<ffffffff8013003b>{try_to_wake_up+1083}
<4>       <ffffffff8014b2f0>{autoremove_wake_function+0} 
<ffffffff8029e38b>{sys_recvmsg+395}
<4>       <ffffffff8018e477>{pipe_writev+1319} 
<ffffffff80181208>{vfs_write+344}
<4>       <ffffffff80181343>{sys_write+83} 
<ffffffff8010dc4e>{system_call+126}
<4>
<4>Badness in __kfree_skb at net/core/skbuff.c:330
<4>
<4>Call Trace:<ffffffff802a2f77>{__kfree_skb+167} 
<ffffffff802bb597>{netlink_recvmsg+279}
<4>       <ffffffff8029cb2b>{sock_recvmsg+315} 
<ffffffff8019b457>{update_atime+151}
<4>       <ffffffff8015ddfa>{do_generic_mapping_read+1098} 
<ffffffff80161311>{buffered_rmqueue+529}
<4>       <ffffffff8012fbe5>{activate_task+149} 
<ffffffff8013003b>{try_to_wake_up+1083}
<4>       <ffffffff8014b2f0>{autoremove_wake_function+0} 
<ffffffff8029e38b>{sys_recvmsg+395}
<4>       <ffffffff8018e477>{pipe_writev+1319} 
<ffffffff80181208>{vfs_write+344}
<4>       <ffffffff80181343>{sys_write+83} 
<ffffffff8010dc4e>{system_call+126}
<4>
<4>Badness in __kfree_skb at net/core/skbuff.c:330
<4>
<4>Call Trace:<ffffffff802a2f77>{__kfree_skb+167} 
<ffffffff802bb597>{netlink_recvmsg+279}
<4>       <ffffffff8029cb2b>{sock_recvmsg+315} 
<ffffffff8019b457>{update_atime+151}
<4>       <ffffffff8015ddfa>{do_generic_mapping_read+1098} 
<ffffffff80161311>{buffered_rmqueue+529}
<4>       <ffffffff8012fbe5>{activate_task+149} 
<ffffffff8013003b>{try_to_wake_up+1083}
<4>       <ffffffff8014b2f0>{autoremove_wake_function+0} 
<ffffffff8029e38b>{sys_recvmsg+395}
<4>       <ffffffff8018e477>{pipe_writev+1319} 
<ffffffff80181208>{vfs_write+344}
<4>       <ffffffff80181343>{sys_write+83} 
<ffffffff8010dc4e>{system_call+126}
<4>
<3>scheduling while atomic: conntrack/0xffffff00/32033
<4>
<4>Call Trace:<ffffffff8031d67d>{schedule+125} 
<ffffffff80181208>{vfs_write+344}
<4>       <ffffffff80181343>{sys_write+83} 
<ffffffff8010dcb8>{sysret_careful+13}
<4>


> I don't think so. Deti reports similer oops on 2.6.14 which has been already
> out, so this should be fixed asap.
good idea.

Deti
