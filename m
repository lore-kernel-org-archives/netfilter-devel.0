From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] introduce ipv6_find_hdr to unify similar loops in IPv6
 matches
Date: Sat, 17 Sep 2005 21:25:02 +0200
Message-ID: <432C6D8E.9050408@trash.net>
References: <200509141615.j8EGF9D2005786@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200509141615.j8EGF9D2005786@toshiba.co.jp>
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
> Some IPv6 matches have very similar loops to find IPv6 extension header
> and we can unify them. This patch introduces ipv6_find_hdr() to do it.
> I just checked that it can find the target headers in the packet which has
> dst,hbh,rt,frag,ah,esp headers.

This patch looks great, applied. It looks like we could also replace
the code in ip6_packet_match, the special treatment of IPPROTO_ESP
doesn't look right anyway.
