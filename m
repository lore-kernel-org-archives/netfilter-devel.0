From: Jiri Slaby <jirislaby@gmail.com>
Subject: Re: Error compile kernel 2.6.11.7 w/ pptp_conntrack_nat
Date: Fri, 12 Aug 2005 03:50:22 +0200
Message-ID: <42FC005E.10104@gmail.com>
References: <20050812020036.9B5D8A28028@insight.ip3.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Derrick Sawyer <derrick@ip3.com>
In-Reply-To: <20050812020036.9B5D8A28028@insight.ip3.com>
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

Derrick Sawyer napsal(a):
> I first applied the pptp_conntrack patch.
> I tried to apply the ctnetlink patch and get "ERROR (5 rejects out of 48 
> hunks)".  I went ahead and forced the patch and got this error when
Hm, the best way is probably to download some latest kernel (i have 
2.6.13-rc5 and there are the functions used by pptp) and apply pptp 
patch there. It is probable, that if there are errors with hunks (pptp 
and ctnetlink could overlap), it'll not work.
One thing went on my mind, you could try combinediff tool, but i haven't 
tried it, so I don't know if it really does, what I mean.
> compiling the kernel:
> CC      net/ipv4/netfilter/ip_conntrack_core.o
> net/ipv4/netfilter/ip_conntrack_core.c: In function 
> `__ip_conntrack_hash_insert':
> net/ipv4/netfilter/ip_conntrack_core.c:355: error: 
> `ip_conntrack_next_id' undeclared (first use in this function)
> net/ipv4/netfilter/ip_conntrack_core.c:355: error: (Each undeclared 
> identifier is reported only once
> net/ipv4/netfilter/ip_conntrack_core.c:355: error: for each function it 
> appears in.)
> make[3]: *** [net/ipv4/netfilter/ip_conntrack_core.o] Error 1
> make[2]: *** [net/ipv4/netfilter] Error 2
> make[1]: *** [net/ipv4] Error 2
> make: *** [net] Error 2
-- 
Jiri Slaby         www.fi.muni.cz/~xslaby
~\-/~      jirislaby@gmail.com      ~\-/~
241B347EC88228DE51EE A49C4A73A25004CB2A10
