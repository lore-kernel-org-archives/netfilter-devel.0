From: Patrick McHardy <kaber@trash.net>
Subject: Re: [BK PATCH] Fix ip_conntrack_amanda data corruption bug that
 breaks amanda dumps
Date: Fri, 05 Nov 2004 00:59:23 +0100
Message-ID: <418AC25B.4060401@trash.net>
References: <418A7B0B.7040803@trash.net>
	<E1CPoUT-0000sk-00@gondolin.me.apana.org.au>
	<20041104130028.099fc130.davem@davemloft.net>
	<418AA4C7.2030909@trash.net>
	<20041104235001.GB30029@merlin.emma.line.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: linux-net@vger.kernel.org, linux-kernel@vger.kernel.org,
	netfilter-devel@lists.netfilter.org,
	Herbert Xu <herbert@gondor.apana.org.au>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matthias Andree <matthias.andree@gmx.de>
In-Reply-To: <20041104235001.GB30029@merlin.emma.line.org>
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

Matthias Andree wrote:

>On Thu, 04 Nov 2004, Patrick McHardy wrote:
>
>
>>-	data = amp;
>>-	data_limit = amp + skb->len - dataoff;
>>+	skb_copy_bits(skb, dataoff, amanda_buffer, skb->len - dataoff);
>>+	data = amanda_buffer;
>>+	data_limit = amanda_buffer + skb->len - dataoff;
>>
>
>Does this mean the whole buffer is still copied?
>
Yes.

>
>If so: Making a local copy of the packet just to be able to stuff NUL
>bytes to suit or "optimize" strstr functions is plain nonsense - amanda
>pipes several GByte through the kernel at each run, and copying
>gazillions of bits around, wasting millions of CPU cycles, just because
>someone is too lazy to spell a more decent search function, is
>bad design.
>
This is just the UDP control connection, the data is not copied
or scanned. Feel free to send a patch that doesn't need to
copy linear skbs and doesn't need to modify the skb.

>Same consideration applies to FTP connection tracking.
>
>I wrote a memstr function for bogofilter (GPL v2) that we could use
>inside the kernel, as a length-limited strstr replacement, as in "search
>the first buffer_size bytes starting with buffer_base for the first
>occurrence of const char *needle". That avoids all buffer modifications
>in ip_conntrack_amanda.c AFAICS. It's also slow because it does a linear
>search and not an optimized search as the sophisticated KMP and other
>search algorithms would be able to do, but then again the generic strstr
>inside the kernel is linear, too.
>
non-linear skb have fragments scattered in memory, you have to
copy them or scan with a function that is aware of how the data
is layed out in memory. Look at Harald's notes from the netfilter
workshop for details on current work in this area.

http://www.netfilter.org/documentation/conferences/nf-workshop-2004-summary.html#AEN499

Regards
Patrick
