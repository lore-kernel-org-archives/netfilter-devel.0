From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] ip_nat_sip: fix compiler warning
Date: Sun, 28 May 2006 16:29:24 +0200
Message-ID: <4479B3C4.1040404@trash.net>
References: <1148823979.32002.2.camel@scaramouche.combox.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
In-Reply-To: <1148823979.32002.2.camel@scaramouche.combox.de>
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

Torsten Luettgert wrote:
> Hi,
> 
> here's a trivial patch for ip_nat_sip which fixes the following
> compiler warning:
> 
> net/ipv4/netfilter/ip_nat_sip.c:97: warning: ISO C90 forbids mixed
> declarations and code


Thanks, but the SIP helper in patch-o-matic is quite out of date.
I have a version with that warning (and some other things) already
fixed queued for upstream submission. After that I'll most likely
remove it from pom.
