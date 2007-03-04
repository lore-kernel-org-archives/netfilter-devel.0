From: Patrick McHardy <kaber@trash.net>
Subject: Re: TCP/UDP checksum in hardware
Date: Sun, 04 Mar 2007 18:16:39 +0100
Message-ID: <45EAFEF7.7050404@trash.net>
References: <c4357ccd0703040726ie905103rd60c87c8a35923c8@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Alexander Sirotkin <demiourgos@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <c4357ccd0703040726ie905103rd60c87c8a35923c8@mail.gmail.com>
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

Alexander Sirotkin wrote:
> It appears that Netfilter does not exploit the hardware TCP/UDP
> checksum functionality present in some network cards, i.e.
> NETIF_F_HW_CSUM. Is there any particular reason why it is not used ?

With pure NAT we do incremental checksumming, which shouldn't be
very expensive. One thing I want to do is offload checksumming in
the cases where we recalculate the entire checksum, but AFAIK thats
only when helpers mangle the packet.

> The reason I'm asking is that computing checksum (in case of NAT, for
> instance) becomes a real problem on embedded devices

Do you have any data to show this?
