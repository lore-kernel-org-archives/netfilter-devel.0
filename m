From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: nf_conntrack (l3 independent conntrack)
Date: Tue, 02 Dec 2003 10:36:10 +0900 (JST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200312020137.KAA06337@toshiba.co.jp>
References: <200311261126.UAA26305@toshiba.co.jp>
	<20031129175622.GN3181@obroa-skai.de.gnumonks.org>
	<200312020035.JAA26549@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: laforge@netfilter.org
In-Reply-To: <200312020035.JAA26549@toshiba.co.jp>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi, Harald,

Sorry, I forgot to say the important thing.

I want to use "union" very much. But.. I'll think of structure and try to
rewrite my code for some time.

From: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
Date: Tue, 02 Dec 2003 09:34:40 +0900 (JST)

> [ short ]
> 
> I agree that we should not care too much about the corner cases, and
> translation of IPv4 (or IPv6) packets is the corner case, IN NOW.
> 
> And, I still seem to misunderstand your idea about tuple.
> 
> I tried to write structure of tuple like that in last week.
> 	- all connection can be represented with nf_conntrack_tuple.
> 	- l4 part and l3 protocol number in tuple can be accessed with l3
> 	  independently.
> 	- operations of tuple are easy as possible.
> 	- only one hash for conntrack is allocated in kernel.
> 
> I don't know these are what you want, or not.
> 
> And, I thought about some types of structure, but all of them have some complexity to operate tuple.
> I needed typecasting, manual calculation of pointer.
> 
> After all, I think that using "union" is simply and better even though wasting
> memory space.
