From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] for some issues in tcp window tracking patch
Date: Fri, 21 May 2004 04:23:49 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AD6835.2060105@trash.net>
References: <Pine.LNX.4.44.0405210317470.14542-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>,
 Jozsef Kadlecsik <kadlec@netfilter.org>,
 Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0405210317470.14542-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom wrote:
> On Fri, 21 May 2004, Pablo Neira wrote:
> 
> 
>>b) We don't need to set assured bit all the time, I think that I told 
>>you, well if so, sorry for repeating me.
> 
> 
>>         } else if ((old_state == TCP_CONNTRACK_SYN_RECV
>>                    || old_state == TCP_CONNTRACK_ESTABLISHED)
>>-                   && new_state == TCP_CONNTRACK_ESTABLISHED)
>>+                 && new_state == TCP_CONNTRACK_ESTABLISHED
>>+                 && !test_bit(IPS_ASSURED_BIT, &conntrack->status)) {
> 
> 
> Are you sure this really is an optimization in the current code? Is 
> test_bit really faster than set_bit when the bit is already set?

It should be, on x86 set_bit locks the bus:

static __inline__ void set_bit(int nr, volatile unsigned long * addr)
{
         __asm__ __volatile__( LOCK_PREFIX
                 "btsl %1,%0"
                 :"=m" (ADDR)
                 :"Ir" (nr));
}

but test_bit doesn't:

static __inline__ int variable_test_bit(int nr, const volatile unsigned 
long * addr)
{
         int oldbit;
 

         __asm__ __volatile__(
                 "btl %2,%1\n\tsbbl %0,%0"
                 :"=r" (oldbit)
                 :"m" (ADDR),"Ir" (nr));
         return oldbit;
}

Regards
Patrick
