From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: [RFC] ipset: New set type iptreemap, kernel part
Date: Tue, 21 Aug 2007 12:20:24 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708211216590.5333@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0708202149370.14154@titan.stealer.net>
	<Pine.LNX.4.64.0708202210010.14154@titan.stealer.net>
	<Pine.LNX.4.64.0708210739410.5333@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0708210817150.26007@titan.stealer.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: Sven Wegener <sven.wegener@stealer.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0708210817150.26007@titan.stealer.net>
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


On Aug 21 2007 08:54, Sven Wegener wrote:
>> > +#define ABCD(a, b, c, d, addr) \
>> > +	do { \
>> > +		a = ((unsigned char *)addr)[3]; \
>> > +		b = ((unsigned char *)addr)[2]; \
>> > +		c = ((unsigned char *)addr)[1]; \
>> > +		d = ((unsigned char *)addr)[0]; \
>> > +	} while (0)
>>
> The macro is taken from the iptree set type. For the *_kernel functions we
> access the skb, which contains Network Order and ntohl() the value. The other
> functions take values parsed by userspace, which is passed to kernel in Host
> Order. So we are actually dealing with Host Order all the time when we use the
> ABCD macro. Seems broken then, thanks. Is there a portable macro for it, or
> should I stick some ifdef __(BIG|LITTLE)_ENDIAN in there and implement it
> myself?

Using &, << and/or >> you should get a portable solution, since these operators
will always operate on hostendians.



	Jan
-- 
