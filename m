From: Unit Zero <onyx@zero.fdns.net>
Subject: Re: taking related connections to the limit
Date: Thu, 4 Mar 2004 17:30:54 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.56L0.0403041728280.12843@zero.fdns.net>
References: <20040304120402.GH14383@magicbluesmoke.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "John P. Looney" <valen@tuatha.org>
In-Reply-To: <20040304120402.GH14383@magicbluesmoke.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Umm, yes I belive you're looking for the "recent" module, a very nice bit 
of code by Stephen Frost <sfrost@snowman.net>.

On Thu, 4 Mar 2004, John P. Looney wrote:

>  Hi, I was wondering if netfilter can do the following:
> 
>  If a packet has dest ip X, dport 110, do a DNAT --to IP Y, record the SRC IP
>  If a subsequent packet comes into dest IP X, from that SRC IP, --dport 25 from the same IP, DNAT --to IP Y also.
> 
>  This is to do some work with POP-before-smtp, if you wondered why such a
> demented thing would be needed. 
> 
> John
> 
> 
