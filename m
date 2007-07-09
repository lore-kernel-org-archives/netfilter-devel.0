From: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Subject: Re: ICMP packets associated with NAT connections sent out wrong
 interface?
Date: Mon, 09 Jul 2007 16:03:08 +0900 (JST)
Message-ID: <200707090703.l69738Dt004529@toshiba.co.jp>
References: <200707070627.l676R79T003388@toshiba.co.jp>
	<200707071224.l67COMEg022741@toshiba.co.jp>
	<468FFFE5.3090506@quo.to>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org,
	yasuyuki.kozakai@toshiba.co.jp
To: jr-list-2007@quo.to
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <468FFFE5.3090506@quo.to>
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


From: Jordan Russell <jr-list-2007@quo.to>

> Yasuyuki KOZAKAI wrote:
> > OK, I try to explain what the current netfilter does in Jordan's situation.
> > I also attach the patch to fix this problem. Jordan, can you try it ?
> 
> Excellent. The patch does appear to fix the problem. I repeated the
> BitTorrent test, and no packets matched my LOG rule.
> 
> I'll keep watching the logs and report back if it happens again.
> 
> Thanks for looking into this!

Thanks for testing.

-- Yasuyuki Kozakai
