From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] fix stats in __ip_conntrack_confirm
Date: Mon, 25 Oct 2004 01:12:27 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <417C36DB.5000403@trash.net>
References: <4176E6EB.1070008@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Eric Lemoine <eric.lemoine@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4176E6EB.1070008@eurodev.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Pablo Neira wrote:

> So net_rx_softirq can preempt the calling process while incrementing 
> the stats.
> I think that we can fix this moving both CONNTRACK_STAT_INC to the locked
> section.

Applied, thanks Pablo.

Regards
Patrick
