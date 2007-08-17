From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: revisit: ipset nethash set type limited to /31
Date: Fri, 17 Aug 2007 13:05:38 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708171303310.5492@fbirervta.pbzchgretzou.qr>
References: <1187333670.3949.81.camel@delta.sgr-a.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
To: "Neville C. Dempsey" <NevilleD.Netfilter@sgr-a.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <1187333670.3949.81.camel@delta.sgr-a.net>
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


On Aug 17 2007 16:54, Neville C. Dempsey wrote:
>
>As ipset_nethash.c stands it handles subnet masks from /1 to /31 fine,
>but the cases /0 & /32 are required to be handled in a different chain.

/0 is not a network anymore, it is "everything".
/32 is a single host, I think iphash is better suited for this.
Or perhaps even use fullipmap 
[https://lists.netfilter.org/pipermail/netfilter-devel/2007-August/029066.html]


	Jan
-- 
