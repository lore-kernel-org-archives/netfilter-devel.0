From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: [PATCH] ipt_do_table accesss pskb after it has been freed
Date: Fri, 7 Nov 2003 19:18:52 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0311071910540.12681-100000@filer.marasystems.com>
References: <3FABC3BF.7070808@metavize.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Harald Welte <laforge@netfilter.org>,
   <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: dmorris <dmorris@metavize.com>
In-Reply-To: <3FABC3BF.7070808@metavize.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Fri, 7 Nov 2003, dmorris wrote:

> What am I supposed to do if there is no skb to be dropped.
> My hook calls some other functions in the kernel which call
> skb_free if all is not well.
> That leaves me with two choices, either make a copy of the skb,
> which i cant do for performance reasons, or apply this patch.

You don't need to copy the skb, but you need to protect it from beeing 
freed if what you are calling is destructive and may call kfree_skb():

i.e. something like this:

   struct skbuff *ref = skb_get(skb);

   /* call possibly destructive function */
  
   if (was_not_destructive) {
       skb_free(ref);
       return NF_ACCEPT;
   } else {
       /* our reference was eaten by the evil destructive call above */B
       return NF_DROP;
   }


Regards
Henrik
