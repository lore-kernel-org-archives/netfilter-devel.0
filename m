From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: How do I use ip_conntrack_destroyed?
Date: Wed, 03 Dec 2003 15:10:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FCDEEB8.8070603@balabit.hu>
References: <3FCDD197.6050700@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: emmanuel@netlab.hut.fi
In-Reply-To: <3FCDD197.6050700@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


   Hi,

Emmanuel Guiton wrote:
> /* Call me when a conntrack is destroyed. */
> extern void (*ip_conntrack_destroyed)(struct ip_conntrack *conntrack);
> 
> So I guess it particularly fits with my needs. But what about using it?
> 
> Does it work so that I have to write something like:
> ip_conntrack_destroyed = &my_counter_function
> in my ipt_xxxx_target function and then do my stuff in my_counter_function?

   The ip_conntrack_destroyed function pointer is actually an ugly hack so 
that NAT is able to clean up when a conntrack entry is destroyed. So, 
changing that pointer is not allowed if you're using NAT.

   I think you'd need the functionality of ctnetlink's notifier 
registration facility. See POM/extra.

-- 
   Regards,
     Krisztian KOVACS
