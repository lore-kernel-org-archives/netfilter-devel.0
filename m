From: Peter Surda <shurdeek@routehat.org>
Subject: Re: [patch] Fix ipt_ACCOUNT for large networks
Date: Mon, 4 Apr 2005 12:19:48 +0200
Message-ID: <20050404101947.GC12663@soldats.localdomain>
References: <200504041102.57717.thomas.jarosch@intra2net.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Thomas Jarosch <thomas.jarosch@intra2net.com>
Content-Disposition: inline
In-Reply-To: <200504041102.57717.thomas.jarosch@intra2net.com>
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

On Mon, Apr 04, 2005 at 11:02:57AM +0200, Thomas Jarosch wrote:
> attached is a small patch to fix the ACCOUNT target for large networks. The
> bug was introduced when the code was more modularized.
Please don't apply yet, this doesn't fix everything, you have to increment
to_user too. I'm working on a version that does this, stay tuned.

> diff -u -r -p ipt_ACCOUNT/linux/net/ipv4/netfilter/ipt_ACCOUNT.c ipt_ACCOUNT.fixed/linux/net/ipv4/netfilter/ipt_ACCOUNT.c
> --- ipt_ACCOUNT/linux/net/ipv4/netfilter/ipt_ACCOUNT.c  2005-04-04 10:36:22.000000000 +0200
> +++ ipt_ACCOUNT.fixed/linux/net/ipv4/netfilter/ipt_ACCOUNT.c    2005-04-04 10:36:57.802104874 +0200
> @@ -714,9 +714,9 @@ int ipt_acc_handle_copy_data(void *to_us
> 
>              /* Temporary buffer full? Flush to userspace */
>              if (*pos+handle_ip_size >= PAGE_SIZE) {
> -                *pos = 0;
>                  if (copy_to_user(to_user, ipt_acc_tmpbuf, *pos))
>                      return -EFAULT;

here it should do something like 
to_user += *p;
except you probably have to cast it etc.

> +                *pos = 0;
>              }
>              memcpy(ipt_acc_tmpbuf+*pos, &handle_ip, handle_ip_size);
>              *pos += handle_ip_size;
Bye,

Peter Surda (Shurdeek) <shurdeek@routehat.org>, ICQ 10236103, +436505122023

-- 
Microsoft and Apple make the easy things very easy and the hard things impossible.
*BSD and Linux make the easy things challenging and the hard things difficult but possible.
