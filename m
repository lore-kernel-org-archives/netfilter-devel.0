From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_TARPIT (was: ipt_account / iptables 1.3.8)
Date: Mon, 09 Jul 2007 15:37:02 +0200
Message-ID: <469239FE.3020904@trash.net>
References: <Pine.LNX.4.64.0707081655470.24717@fbirervta.pbzchgretzou.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kadlec@blackhole.kfki.hu
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707081655470.24717@fbirervta.pbzchgretzou.qr>
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

Jan Engelhardt wrote:
> in http://lists.netfilter.org/pipermail/netfilter-devel/2007-June/028366.html
> there was talk about a revamped xt_TARPIT.
> 
> Patrick McHardy wrote:
> 
>>Shouldn't be much work, maybe I'll look into this after finishing
>>my conntrack hash patches if no one beats me to it.
> 
> 
> Any progress? Because tarpit is in my series [kernel patch tree] (after 
> connlimit), and I'd hate to do double effort if you already have it.


No, I couldn't come up with a good way to remove the xrlim abuse yet.
