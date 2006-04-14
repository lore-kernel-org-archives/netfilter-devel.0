From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: [PATCH 2/4] kill manually comparing protocol name with
 "ipv6-icmp"
Date: Fri, 14 Apr 2006 10:02:00 +0900 (JST)
Message-ID: <200604140102.k3E121Xd027817@toshiba.co.jp>
References: <200604071131.k37BVY3F025271@toshiba.co.jp>
	<443A493A.5030307@ufomechanic.net>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, netfilter-devel@lists.netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: azez@ufomechanic.net
In-Reply-To: <443A493A.5030307@ufomechanic.net>
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


From: Amin Azez <azez@ufomechanic.net>
Date: Mon, 10 Apr 2006 13:02:02 +0100

> Yasuyuki KOZAKAI wrote:
> > [IP6TABLES] kill manually comparing protocol name with "ipv6-icmp"
> > 
> > This adds "ipv6-icmp" to chain_protos[] and kill manually comparing
> > the argument of '-p' with it.
> > 
> > chain_protos[] has the "icmpv6" with the same protocol number, but it's
> > OK because proto_to_name() returns the firstly matched entry "icmpv6"
> > as ever.
> 
> I'm uncomfortable with having proto names in source code anyway, to me 
> it clashes horribly with getprotobyname and friends which for historical 
> and bizarre reasons might be looked up centrally (using nss) via ldap !!
> 
> However I guess history also shows that protocol names have been stable 
> over the years :-) so what can I say?

For ease to use and to avoid confusing, I'm comfortable with having protocol
names until stable name of them are spread widely.

For example, /etc/protocols in Fedora Core 5 is based on RFC1340, which was
obsoleted (Currently protocol name list is published by IANA:
http://www.iana.org). It includes "ipv6-crypt" and "ipv6-auth", they ware
replaced with "esp" and "ah" in IANA list.

On the other hand, I heard Debian has later names (correct ?).

It's better to push distributors to update /etc/protocols if people
want to use later names without hard coding in the future.

About other protocol names (tcp, udp, ...), I don't know detail reason
to keep them in iptables. I imagine it's such as guarantee of usability.

-- Yasuyuki Kozakai
