From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: stealing packets
Date: Mon, 24 Nov 2003 02:34:31 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311240228540.7951-100000@filer.marasystems.com>
References: <20031124010359.21595.qmail@web60703.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Zeeshan Ali <zeelists@yahoo.com>
In-Reply-To: <20031124010359.21595.qmail@web60703.mail.yahoo.com>
ReSent-Message-ID: <Pine.LNX.4.44.0311240235200.7951@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Sun, 23 Nov 2003, Zeeshan Ali wrote:

>     Yeah, i know that but the kernel does'nt like it
> when you re-inject the packet sometimes later. E.g
> this simple test code inside the queue handler
> function caused a kernel panic:
> 
>   static struct sk_buff *next = NULL;
>  
>   if (next != NULL) {
>     nf_reinject (next, info, NF_ACCEPT);
>   }
> 
>   next = skb;
> 
>   return 0; /* what should be the return value? */

You need to pass back the same skb,info pair... other than that it should
work from what I can tell..

The return code is 0 for success, -ERRNO on error where ERRNO is a 
suitable error code describing the error.

> BTW, my first question still remains unanswered :(

I don't remember what the question was and it has already been deleted
from my inbox. Maybe if you repost the questsion. But probably it was 
outside what I know to answer and is why it was deleted..

Regards
Henrik
