From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: ipsec and nat history
Date: Tue, 8 Nov 2005 18:35:20 +0100
Message-ID: <BAY103-DAV1DBB3B5788F2F1F3852BDB2640@phx.gbl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

I was browsing netfilter-dev archive about the issues with NAT
and IPsec. I was reading this message (27 Jan 2004) from Harald:

https://lists.netfilter.org/pipermail/netfilter-devel/2004-January/013903.html

"...We could even pass a dummy output device structure
with an interface name "esp" so people can SNAT
everything heading for esp encapsulation..."

Lately Michael Richardson wrote:

https://lists.netfilter.org/pipermail/netfilter-devel/2004-January/013956.html

"...I would suggest that many administrators will want
to have possibly a pseudo-interface per SA. These
aren't necessarily real interfaces like ipsecX, but they
do need to be named in some way..."

Is this approach (virtual/pseudo/dummy device) abandoned?

TIA
