From: Patrick McHardy <kaber@trash.net>
Subject: Re: [1/3] OSF: code beautification.
Date: Sat, 11 Jun 2005 18:56:55 +0200
Message-ID: <42AB17D7.4060007@trash.net>
References: <20050530002000.4c63b34b@zanzibar.2ka.mipt.ru>	<42AB11B1.6010605@trash.net>
	<20050611204419.67e0ef47@zanzibar.2ka.mipt.ru>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: johnpol@2ka.mipt.ru
In-Reply-To: <20050611204419.67e0ef47@zanzibar.2ka.mipt.ru>
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

Evgeniy Polyakov wrote:
> please try apply "[0/3] OSF: resurect skb fragmentation patch." first,
> it must fix above[skipped] issue.

Thanks, I've applied all patches. There still was on reject in
include/linux/netfilter_ipv4/ipt_osf.h, but I fixed it up manually.
