From: Laszlo Valko <valko@linux.karinthy.hu>
Subject: Re: [PATCH] New match module: byte rate match
Date: Tue, 21 Jan 2003 16:51:52 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030121165152.A24205@linux.karinthy.hu>
References: <Pine.LNX.4.44.0301161438250.2232-100000@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chris Wilson <chris@netservers.co.uk>
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.44.0301161438250.2232-100000@localhost>; from chris@netservers.co.uk on Mon, Jan 20, 2003 at 03:58:19PM +0000
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, Jan 20, 2003 at 03:58:19PM +0000, Chris Wilson wrote:
> Hi all,
> 
> NetServers.co.uk would like to submit a new module for your perusal and
> hopefully for inclusion in Netfilter. It's based on ipt_limit, but matches
> the number of bytes per second instead of the number of packets. This
> means that it can be used for basic quality-of-service implementation,
> thus:

Hi Chris!

Please consider fixing this structure:

struct ipt_bytelimit_info {
       /* Public parameters, supplied from user space */
       u_int32_t rate;       /* Number of bytes credited per second */
       u_int32_t credit_cap; /* Maximum credit which may accumulate */

       /* Used internally by the kernel */
       u_int32_t jiffy_rate; /* Number of bytes credited per jiffy */
       unsigned long prev;   /* Time of last match, in jiffies */
       u_int32_t credit;     /* Current balance */
};

Using unsigned long in there will make your code inoperable on 64bit
platforms with 32bit userspace. Please change it to something similar
to this one:

struct ipt_bytelimit_info {
       /* Public parameters, supplied from user space */
       u_int32_t rate;       /* Number of bytes credited per second */
       u_int32_t credit_cap; /* Maximum credit which may accumulate */ 

       /* Used internally by the kernel */
       u_int32_t jiffy_rate; /* Number of bytes credited per jiffy */
       u_int32_t credit;     /* Current balance */
       union {
             unsigned long prev;   /* Time of last match, in jiffies */
             u_int8_t padding[8];  /* Cover prev always */
       } u;
};
   
Moving credit field upwards one slot will make the structure more
compact on 64bit platforms (24 bytes instead of 28).

You might as well eliminate unsigned long totally, but I'm not sure
whether it's easy considering that jiffies is unsigned long.


Also this is incorrect as r->credit is not of type int,

               DEBUGP("ipt_bytelimit: accepted %d bytes, "
                       "remaining credit %d\n", packet_size, r->credit);

so you should use the appropriate format specifier (%lu for unsigned long).


I know ipt_limit (that your module is based on) is broken as well,
but it's not easy to fix it without breaking compatibility. On the other
hand, we should not replicating a broken interface...

Laszlo
