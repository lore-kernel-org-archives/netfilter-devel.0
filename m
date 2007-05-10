From: David Miller <davem@davemloft.net>
Subject: Re: [NETFILTER 06/09]: nf_nat: Clears helper private area when
 NATing
Date: Thu, 10 May 2007 14:16:31 -0700 (PDT)
Message-ID: <20070510.141631.42906695.davem@davemloft.net>
References: <20070510134027.8559.40540.sendpatchset@localhost.localdomain>
	<20070510134035.8559.15799.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070510134035.8559.15799.sendpatchset@localhost.localdomain>
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
Date: Thu, 10 May 2007 15:41:18 +0200 (MEST)

> [NETFILTER]: nf_nat: Clears helper private area when NATing
> 
> Some helpers (eg. ftp) assume that private area in conntrack is
> filled with zero. It should be cleared when helper is changed.
> 
> Signed-off-by: Yasuyuki Kozakai <yasuyuki.kozakai@toshiba.co.jp>
> Signed-off-by: Patrick McHardy <kaber@trash.net>

Applied.
