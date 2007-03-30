From: Patrick McHardy <kaber@trash.net>
Subject: Re: unregister_netdevice with negative refcnt error while using
 NFQUEUE with ebtables mark
Date: Fri, 30 Mar 2007 15:21:34 +0200
Message-ID: <460D0EDE.6070401@trash.net>
References: <74ECB30468A30A4DA2BD88DA5387CAE3508835@fempexch.FireEye.com>
	<46093551.2060906@trash.net>
	<74ECB30468A30A4DA2BD88DA5387CAE3508A49@fempexch.FireEye.com>
	<460A3653.6020501@trash.net>
	<74ECB30468A30A4DA2BD88DA5387CAE3508AEB@fempexch.FireEye.com>
	<460B9DFC.3020806@trash.net>
	<74ECB30468A30A4DA2BD88DA5387CAE3508BA7@fempexch.FireEye.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Jay Manni <JManni@FireEye.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <74ECB30468A30A4DA2BD88DA5387CAE3508BA7@fempexch.FireEye.com>
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
> The final refcnt (abs value) is much less than the number of the packets queued. The total packets queued in my tests have usually been on the order of about 300 to 500 packets. And the refcnt has been between -30 to -60.
> 
> Maybe I can try more tests and see if there is any obvious relation .. but it doesn't appear to be.


Still can't find the problem. Can you test 2.6.20 or the current -git
kernel please?
