From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] libiptc.c blob parser
Date: Fri, 07 Jul 2006 06:21:25 +0200
Message-ID: <44ADE145.7020508@trash.net>
References: <FFEPKIHJDEDDAAFOFDGFOELECBAA.PCDiem@FoxValley.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jesper Dangaard Brouer <hawk@diku.dk>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "Paul C. Diem" <PCDiem@FoxValley.net>
In-Reply-To: <FFEPKIHJDEDDAAFOFDGFOELECBAA.PCDiem@FoxValley.net>
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

Paul C. Diem wrote:
> The patch I posted earlier assumed that the rule's chain was the last one on
> the chain list and used the 32-bit comefrom field to hold the offset of the
> chain list entry.
> 
> This improved patch uses the chain_iterator_cur handle field to more
> accurately get the chain, uses the counters field cast as a pointer to hold
> a pointer directly to the chain list entry and only bothers to load the
> pointer for the first rule in each chain (since that's the only one we need
> it in).

I'm not very familiar with that code, so I wonder how that affects
the counter values if you specifially set them or use iptables-save
--counters.
