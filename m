From: Martijn Lievaart <m@rtij.nl>
Subject: Re: Userspace packet queuing with libipq: ip_conntrack does
	not	defragment?
Date: Wed, 09 May 2007 18:34:22 +0200
Message-ID: <4641F80E.8050103@rtij.nl>
References: <22b256140705090832v556bee45ne5119d529a7e310e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Michael Ransburg <michael.ransburg@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <22b256140705090832v556bee45ne5119d529a7e310e@mail.gmail.com>
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

Michael Ransburg wrote:
> However, since ip_conntrack is loaded I would expect that
> the packets are defragmented before they are passed to my userspace
> appliation (as indicated here for example:
> http://lists.netfilter.org/pipermail/netfilter/2002-May/034006.html).
> This does not seem the case, i.e., the maximum size of the packets
> which I get (through ->data_len) is 1500 bits.
>
> The len parameter of the ipq_read method is well over 1500, as is the
> buffer size.

Do you actually have packets greater than 1500 bytes? That would mean 
you send over loopback, tokenring, etc, but NOT ethernet.

Maybe you are confusing datagram and packet fragmentation. Conntrack 
only defragments packets, not datagrams.

HTH,
M4
