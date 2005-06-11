From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH NF_CONNTRACK 1/9]: Fix multiple problems with TCP window
 tracking
Date: Sat, 11 Jun 2005 17:42:41 +0200
Message-ID: <42AB0671.3020600@trash.net>
References: <200505230617.j4N6HROa027617@toshiba.co.jp>	<200505231546.58751.michal@rokos.info>
	<200505240153.j4O1r3aa008625@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
In-Reply-To: <200505240153.j4O1r3aa008625@toshiba.co.jp>
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
> In this time, I applied
> 	http://numenor.coreworks.de/~kaber/nf_conntrack-03052005_01.diff
> 
> to cloned linus tree at 2005/05/22 00:37(JST: +9:00) before making their
> patches.
> 
> Which tree should I try to keep to update ?

I'm only updateing this tree myself and I think it contains some extra
fixes not found in pom, so probably best to work of this tree for now.
If it makes things easier for you I can extract the additional patches,
apply them to pom and continue to work with that ..

Regards
Patrick
