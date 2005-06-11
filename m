From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_conntrack_standalone / sprintf to buffer
Date: Sat, 11 Jun 2005 17:57:02 +0200
Message-ID: <42AB09CE.6070103@trash.net>
References: <87oeb1b29t.fsf@deprecated.intranet.astaro.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Sven Schnelle <svens@gmx.de>
In-Reply-To: <87oeb1b29t.fsf@deprecated.intranet.astaro.de>
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

Sven Schnelle wrote:
> Hi,
> 
> found the following code snippet in ip_conntrack_standalone.c:145
> in function conntrack_iterate():
> -------------------000000------8<-----------------------------
> 	newlen = print_conntrack(buffer + *len, hash->ctrack);
> 	printk("len + newlen: %d maxlen: %d\n", *len + newlen, maxlen);
> 	if (*len + newlen > maxlen)
> 		return 1;
> 	else *len += newlen;
> -------------000000------------8<-----------------------------
> 
> print_conntrack() uses sprintf without length checking. And now i'm
> wondering what happens if for example, maxlen=3072 and
> len=3071. print_conntrack uses sprintf, writes beyond the end the buffer, and
> after this the check (*len + newlen > maxlen) is done. Looks to me like
> a bug.
> 
> Did i missed something?

Yes, /proc reserves some space (I think its 1k) for writing over
the boundaries.

Regards
Patrick
