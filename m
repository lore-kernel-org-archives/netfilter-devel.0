From: Massimiliano Hofer <max@nucleus.it>
Subject: Re: [PATCH] entry_data
Date: Mon, 19 Jun 2006 09:02:08 +0200
Message-ID: <200606190902.09597.max@nucleus.it>
References: <200606050029.08602.max@nucleus.it>
	<200606132256.10384.max@nucleus.it>
	<4495EC8E.6030006@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4495EC8E.6030006@netfilter.org>
Content-Disposition: inline
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

On Monday 19 June 2006 2:15 am, Pablo Neira Ayuso wrote:

> Unfortunately, your patch breaks old iptables binaries, so it can't
> guarantee backward compatibility :(

I explicitly devoloped it in order not to break compatibility with userspace. 
Did you test it? What problems did you experience?

Of course I break API compatibility within the kernel, so this is an all or 
nothing patch. If people think it's useful it should be merged in the 
mainline kernel and every patchlet updated accordingly.

I think this API is cleaner and more expressive.

>                          /* Used inside the kernel */
>                          struct xt_match *match;
> +                       void *entry_data;
>                  } kernel;
>
> You can't modify the layout of xt_entry_[match|target] since this
> structure is shared between userspace (iptables) and kernel space.

You're right, but I modified the kernel side of a union and I was careful not 
to change the total size. This union is never really used by both sides 
simultaneously.

-- 
Saluti,
   Massimiliano Hofer
        Nucleus
