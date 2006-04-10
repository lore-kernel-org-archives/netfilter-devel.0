From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH 2/4] kill manually comparing protocol name with
	"ipv6-icmp"
Date: Mon, 10 Apr 2006 13:02:02 +0100
Message-ID: <443A493A.5030307@ufomechanic.net>
References: <200604071131.k37BVY3F025271@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: laforge@netfilter.org, kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <200604071131.k37BVY3F025271@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> [IP6TABLES] kill manually comparing protocol name with "ipv6-icmp"
> 
> This adds "ipv6-icmp" to chain_protos[] and kill manually comparing
> the argument of '-p' with it.
> 
> chain_protos[] has the "icmpv6" with the same protocol number, but it's
> OK because proto_to_name() returns the firstly matched entry "icmpv6"
> as ever.

I'm uncomfortable with having proto names in source code anyway, to me 
it clashes horribly with getprotobyname and friends which for historical 
and bizarre reasons might be looked up centrally (using nss) via ldap !!

However I guess history also shows that protocol names have been stable 
over the years :-) so what can I say?

Sam
