From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 14/13]: Fix NAT PMTUD problems
Date: Sun, 19 Feb 2006 09:48:12 +0100
Message-ID: <43F830CC.4080502@trash.net>
References: <43F77A08.4030308@trash.net>
	<20060219.004445.68815246.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20060219.004445.68815246.davem@davemloft.net>
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

David S. Miller wrote:
> I think this belongs in net-2.6, is that where you want me to
> put it?

OK. There were enough netfilter patches touching critical spots
in the last -rc to make me feel a bit uncomfortable, which is
why I'm trying to keep it to a minimum.
