From: Zeeshan Ali <zeelists@yahoo.com>
Subject: Re: stealing packets
Date: Sun, 23 Nov 2003 17:06:29 -0800 (PST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20031124010629.24469.qmail@web60710.mail.yahoo.com>
References: <Pine.LNX.4.44.0311240039520.6878-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <Pine.LNX.4.44.0311240039520.6878-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,
  Thanks for responding. 

> If the hook returns NF_QUEUE then the packet will be
> sent to the netfilter 
> queue handler from where it can later be reinjected
> and will then continue 
> on the next hook.

    Yeah, i know that but the kernel does'nt like it
when you re-inject the packet sometimes later. E.g
this simple test code inside the queue handler
function caused a kernel panic:

  static struct sk_buff *next = NULL;
 
  if (next != NULL) {
    nf_reinject (next, info, NF_ACCEPT);
  }

  next = skb;

  return 0; /* what should be the return value? */

    BTW, my first question still remains unanswered :(
Anyway, I 've just re-compiled the kernel with a lot
of debuging into the routing code, so i gues that
would help to identify my problem. Anyway, thanks for
replying. Bye.

__________________________________
Do you Yahoo!?
Protect your identity with Yahoo! Mail AddressGuard
http://antispam.yahoo.com/whatsnewfree
