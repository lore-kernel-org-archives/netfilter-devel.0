From: Patrick McHardy <kaber@trash.net>
Subject: Re: unregister_netdevice with negative refcnt error while using
 NFQUEUE with ebtables mark
Date: Wed, 28 Mar 2007 11:33:07 +0200
Message-ID: <460A3653.6020501@trash.net>
References: <74ECB30468A30A4DA2BD88DA5387CAE3508835@fempexch.FireEye.com>
	<46093551.2060906@trash.net>
	<74ECB30468A30A4DA2BD88DA5387CAE3508A49@fempexch.FireEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jay Manni <JManni@FireEye.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <74ECB30468A30A4DA2BD88DA5387CAE3508A49@fempexch.FireEye.com>
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

Jay Manni wrote:
> Kernel version - 2.6.15.4
> I am using the nfnetlink_queue and haven't been able to reproduce without queueing.


Please send the exact commands you use for queueing
and whether these packets are bridged or routed.
