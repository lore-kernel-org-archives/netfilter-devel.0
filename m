From: Patrick McHardy <kaber@trash.net>
Subject: Re: [patch] netfilter: implement TCPMSS target for IPv6
Date: Mon, 15 Jan 2007 09:39:38 +0100
Message-ID: <45AB3DCA.9020204@trash.net>
References: <20070114192011.GA6270@clipper.ens.fr>
	<Pine.LNX.4.61.0701142110250.11926@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: David Madore <david.madore@ens.fr>, netfilter-devel@lists.netfilter.org,
	linux-kernel@vger.kernel.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0701142110250.11926@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> On Jan 14 2007 20:20, David Madore wrote:
> 
>>Implement TCPMSS target for IPv6 by shamelessly copying from
>>Marc Boucher's IPv4 implementation.
>>
>>Signed-off-by: David A. Madore <david.madore@ens.fr>
> 
> 
> Would not it be worthwhile to merge ipt_TCPMSS and
> ip6t_TCPMSS to xt_TCPMSS instead?

I'm not sure how well that will work (the IPv4/IPv6-specific stuff
is spread over the entire target function), but its worth a try.
