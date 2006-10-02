From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 00/05]: Small netfilter update
Date: Mon, 02 Oct 2006 16:13:44 -0700 (PDT)
Message-ID: <20061002.161344.92582699.davem@davemloft.net>
References: <20061002154716.13121.53265.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: kaber@trash.net
In-Reply-To: <20061002154716.13121.53265.sendpatchset@localhost.localdomain>
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

From: Patrick McHardy <kaber@trash.net>
Date: Mon,  2 Oct 2006 17:46:03 +0200 (MEST)

> following is a small netfilter update for 2.6.19. The first three patches
> are fixes (Kconfig dependency fix and Horms' LVS routing fix), one patch
> to remove the duplicated route_me_harder code from ipt_REJECT and Bart's
> ebt_mark patch. I know I'm a little late, but I hope its they're still
> fine since they're quite small.
> 
> Please apply, thanks.

Applied.

Please submit the bug fixes as you see fit to -stable, in particular
I'd like to see the Kconfig dependency fix go to 2.6.18-stable.  You
can use this signoff line for any of those patches when submitting
to -stable, thanks:

Signed-off-by: David S. Miller <davem@davemloft.net>
