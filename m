From: Chris Wilson <chris@netservers.co.uk>
Subject: Re: [PATCH] New match module: byte rate match
Date: Tue, 21 Jan 2003 17:12:47 +0000 (GMT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0301211709150.2378-100000@localhost>
References: <20030121165152.A24205@linux.karinthy.hu>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Laszlo Valko <valko@linux.karinthy.hu>
In-Reply-To: <20030121165152.A24205@linux.karinthy.hu>
ReSent-Message-ID: <Pine.LNX.4.44.0301211728010.2378@localhost>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Laszlo,

Thank you for your advice and comments, which I have followed. You can 
find the updated version at:

  'http://www.netservers.co.uk/gpl/iptables-bytelimit-030121.tar.gz'

> Using unsigned long in there will make your code inoperable on 64bit
> platforms with 32bit userspace. Please change it to something similar
> to this one:
> 
> struct ipt_bytelimit_info {
>        /* Public parameters, supplied from user space */
>        u_int32_t rate;       /* Number of bytes credited per second */
>        u_int32_t credit_cap; /* Maximum credit which may accumulate */ 
> 
>        /* Used internally by the kernel */
>        u_int32_t jiffy_rate; /* Number of bytes credited per jiffy */
>        u_int32_t credit;     /* Current balance */
>        union {
>              unsigned long prev;   /* Time of last match, in jiffies */
>              u_int8_t padding[8];  /* Cover prev always */
>        } u;
> };

OK, I made it exactly like the above.

> You might as well eliminate unsigned long totally, but I'm not sure
> whether it's easy considering that jiffies is unsigned long.

I think prev should be the same type as jiffies, otherwise it makes 
cross-platform compatibility worse, not better =(

> Also this is incorrect as r->credit is not of type int,
> 
>                DEBUGP("ipt_bytelimit: accepted %d bytes, "
>                        "remaining credit %d\n", packet_size, r->credit);
> 
> so you should use the appropriate format specifier (%lu for unsigned long).

r->credit is not an unsigned long either, it's u_int32_t, but I 
assume you know what you're doing so I changed that too.

> I know ipt_limit (that your module is based on) is broken as well,
> but it's not easy to fix it without breaking compatibility. On the other
> hand, we should not replicating a broken interface...

No, I certainly agree.

Cheers, Chris.
-- 
   ___ __     _
 / __// / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_ / ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\ _//_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
