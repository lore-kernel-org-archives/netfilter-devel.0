From: Jordan Russell <jr-list-2007@quo.to>
Subject: Re: ICMP packets associated with NAT connections sent out wrong
	interface?
Date: Thu, 05 Jul 2007 19:50:52 -0500
Message-ID: <468D91EC.5090103@quo.to>
References: <468C86C9.7050204@quo.to>	<200707051117.l65BHBA6013655@toshiba.co.jp>	<468CE260.2040500@trash.net>
	<200707060014.l660EMSv000026@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
	kaber@trash.net
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200707060014.l660EMSv000026@toshiba.co.jp>
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
> Jordan, is there the message "nf_conntrack: table full, dropping packet"
> in your log ? I've heard that BitTorrent creates huge connections.

No; there are no messages from the kernel other than "nf_ct_icmp: bad HW
ICMP checksum" and "[packet out wrong interface]" (my LOG rule).

Note that my LOG rule isn't only triggered when using BitTorrent. It's
hit during normal web browsing from the client machines too (i.e.
outbound port 80 through my MASQUERADE rule), just not nearly as often.

-- 
Jordan Russell
