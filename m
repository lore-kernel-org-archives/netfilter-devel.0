From: Patrick McHardy <kaber@trash.net>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Sun, 04 Dec 2005 17:09:03 +0100
Message-ID: <4393149F.8080302@trash.net>
References: <4361EAAB.1090206@fliegl.de>
	<4361F6DF.3050106@eurodev.net>	<43621028.40705@fliegl.de>
	<43627A8F.9060307@eurodev.net> <436281BB.2010100@fliegl.de>
	<4392510A.3030400@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Deti Fliegl <deti@fliegl.de>, netfilter-devel@lists.netfilter.org,
	romary@nikoon.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <4392510A.3030400@eurodev.net>
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

Pablo Neira Ayuso wrote:
> Hi Patrick,
> 
> Deti Fliegl wrote:
> 
>>The kernel oops still happens - but this time I had access to the
>>console (hope that helps):
>>
>><4>Badness in __kfree_skb at net/core/skbuff.c:330
>><4>
>><4>Call Trace:<ffffffff802a2f77>{__kfree_skb+167}
>><ffffffff802bb597>{netlink_recvmsg+279}
>><4>       <ffffffff8029cb2b>{sock_recvmsg+315}
>><ffffffff8025a4d8>{n_tty_receive_buf+4392}
>><4>       <ffffffff8025a4d8>{n_tty_receive_buf+4392}
>><ffffffff8015d828>{filemap_nopage+424}
>><4>       <ffffffff8013003b>{try_to_wake_up+1083}
>><ffffffff8014b2f0>{autoremove_wake_function+0}
>><4>       <ffffffff8025bbd9>{pty_write+89}
>><ffffffff8029e38b>{sys_recvmsg+395}
>><4>       <ffffffff80130f23>{__wake_up+67}
>><ffffffff80181208>{vfs_write+344}
>><4>       <ffffffff80181343>{sys_write+83}
>><ffffffff8010dc4e>{system_call+126}
>><4>
>><3>scheduling while atomic: conntrack/0xffffff00/7887
> 
> 
> Romary Sonrier is reporting a similar problem on a i586 box:
> 
> https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=409
> 
> I can't see a way how the ctnetlink code can trigger that oops at moment
> :(. Any clue on this?

Interesting. I guess that rules out bad hardware in Deti's case. I still
can't see how this can happen, but I'm going to have another look.
