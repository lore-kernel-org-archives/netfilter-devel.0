From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: netfilter QUEUE target and packet socket interactions buggy or
	not
Date: Wed, 14 Sep 2005 15:20:55 +0300
Message-ID: <87irx396xk.fsf@aka.i.naked.iki.fi>
References: <87fysa9bqt.fsf@aka.i.naked.iki.fi>
	<20050912.151120.104514011.davem@davemloft.net>
	<87br2xap9o.fsf@aka.i.naked.iki.fi>
	<877jdl9r1u.fsf@aka.i.naked.iki.fi> <4326FF69.9060004@trash.net>
	<873bo8akvk.fsf@aka.i.naked.iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <873bo8akvk.fsf@aka.i.naked.iki.fi> (Nuutti Kotivuori's message
	of "Tue, 13 Sep 2005 21:22:07 +0300")
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

Nuutti Kotivuori wrote:
> Patrick McHardy wrote:
>> This means inode->i_security was NULL. AFAICT it is only set to NULL in
>> inode_free_security() when the inode is freed. This shouldn't happen
>> while the packet is queued since the skb should hold a reference to
>> the socket on the output path. So it could be some protocol forgetting
>> to increase the refcnt when taking a reference.
>
> Right.

Okay, I said "right" because I did not have time to read the code and
really understand what's happening ;-)

Now I did - and I hope I got it right. So what you are saying is that
the skb is just fine, but the skb references a socket (skb->sk) and
that socket has been freed, even though the skb still lives? And
because of that, SOCK_INODE(skb->sk->sk_socket)->i_security is NULL,
so accessing sclass from there causes the kernel panic?

If that is correct, then I guess I could add a test to see if
i_security member is NULL - and if so, print out a hexdump of the
packet. Or even, as a really hackish workaround, just return NF_ACCEPT
if that's the case (selinux isn't really needed here, just enabled by
default).

But also, if it is that particular spot that causes this exact crash -
the problem should go away if selinux is disabled, even though the bug
still exists (socket being freed before skb stops referencing it).

Just brainstorming here, so people can point out flaws in my thinking
if they happen to stumble on such. I will investigate further.

-- Naked
