From: Patrick McHardy <kaber@trash.net>
Subject: Re: REDIRECT and IPv6
Date: Thu, 19 Jul 2007 12:20:39 +0200
Message-ID: <469F3AF7.6040006@trash.net>
References: <1246.130.217.140.56.1184804730.squirrel@webmail.treenet.co.nz>	<469F280B.3070900@trash.net>
	<20070719.182116.64281593.yoshfuji@linux-ipv6.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: squid3@treenet.co.nz, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org, kaber@trash.net
To: YOSHIFUJI Hideaki <yoshfuji@linux-ipv6.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070719.182116.64281593.yoshfuji@linux-ipv6.org>
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

YOSHIFUJI Hideaki / $B5HF#1QL@ wrote:
> In article <469F280B.3070900@trash.net> (at Thu, 19 Jul 2007 10:59:55 +0200), Patrick McHardy <kaber@trash.net> says:
> 
> 
>>You're right, nf_conntrack_ipv4 only registeres SO_ORIGINAL_DST for
>>AF_INET, changing that should make it work I believe. I feel like
>>I'm missing something though ..
> 
> 
> BTW, the name of the socket option is rather bogus.
> It should be named IP_xxx, not SO_xxx because
> it is in IP level, not in socket level...


True, but its too late to change, we'd need to keep it around at
least for userspace. With TPROXY redirection should work with all
families, so presuming we'll merge it some day this might actually
be useful.
