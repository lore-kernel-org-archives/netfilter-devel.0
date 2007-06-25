From: Jan Engelhardt <jengelh@computergmbh.de>
Subject: Re: xt_connlimit 20070625
Date: Mon, 25 Jun 2007 17:14:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706251714380.3137@fbirervta.pbzchgretzou.qr>
References: <Pine.LNX.4.64.0706201127080.5731@fbirervta.pbzchgretzou.qr>
	<467BAF07.6020502@trash.net>
	<Pine.LNX.4.64.0706251309521.3137@fbirervta.pbzchgretzou.qr>
	<467FA9CE.8000805@trash.net>
	<Pine.LNX.4.64.0706251405280.3137@fbirervta.pbzchgretzou.qr>
	<467FB87D.9020004@trash.net>
	<Pine.LNX.4.64.0706251451000.3137@fbirervta.pbzchgretzou.qr>
	<467FD52E.4050705@trash.net>
	<Pine.LNX.4.64.0706251701180.3137@fbirervta.pbzchgretzou.qr>
	<467FD9C1.9090908@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <467FD9C1.9090908@trash.net>
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


On Jun 25 2007 17:05, Patrick McHardy wrote:
>Jan Engelhardt wrote:
>> On Jun 25 2007 16:46, Patrick McHardy wrote:
>>>static int hash(...)
>>>{
>>>	if (unlikely(!hash_rnd_initted)) {
>>>		get_random_bytes(&hash_rnd, 4);
>>>		hash_rnd_initted = 1;
>>>	}
>> 
>> Looks expensive, though.
>
>Its executed once.

I mean the if().


	Jan
-- 
