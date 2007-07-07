From: Jordan Russell <jr-list-2007@quo.to>
Subject: Re: ICMP packets associated with NAT connections sent out wrong
	interface?
Date: Sat, 07 Jul 2007 16:04:37 -0500
Message-ID: <468FFFE5.3090506@quo.to>
References: <468C86C9.7050204@quo.to>
	<468E7F00.5070307@quo.to>	<200707070627.l676R79T003388@toshiba.co.jp>
	<200707071224.l67COMEg022741@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-bounces@lists.netfilter.org>
In-Reply-To: <200707071224.l67COMEg022741@toshiba.co.jp>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Yasuyuki KOZAKAI wrote:
> OK, I try to explain what the current netfilter does in Jordan's situation.
> I also attach the patch to fix this problem. Jordan, can you try it ?

Excellent. The patch does appear to fix the problem. I repeated the
BitTorrent test, and no packets matched my LOG rule.

I'll keep watching the logs and report back if it happens again.

Thanks for looking into this!

-- 
Jordan Russell
