From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_u32 20070626 (Re: VLAN match within iptables)
Date: Tue, 26 Jun 2007 16:05:43 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706261605140.3137@fbirervta.pbzchgretzou.qr>
References: <1182849745.22167.13.camel@blas> <4680E3D7.6020401@netfilter.org>
	<4680E5CC.8070807@trash.net>
	<Pine.LNX.4.64.0706261423150.3137@fbirervta.pbzchgretzou.qr>
	<46810B7A.5020609@trash.net>
	<Pine.LNX.4.64.0706261511140.3137@fbirervta.pbzchgretzou.qr>
	<46811258.9020309@trash.net>
	<Pine.LNX.4.64.0706261528330.3137@fbirervta.pbzchgretzou.qr>
	<46811675.3090307@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46811675.3090307@trash.net>
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


On Jun 26 2007 15:36, Patrick McHardy wrote:
> Jan Engelhardt wrote:
>> Hm, some UTF-8 got broken. 
>>   
>
> I noticed that and removed the broken part. So unless there's some
> other difference (and the 3 -> 4) I'm leaving it as it is.

I also did the BUG_ON(side_effect) separation in the most recent patch.


	Jan
-- 
