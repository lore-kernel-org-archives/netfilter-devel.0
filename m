From: "ArcosCom Linux User" <linux@arcoscom.com>
Subject: Re: iptables 1.3.7, kernel 2.6.19, ROUTE and Layer7 issues
Date: Wed, 13 Dec 2006 10:12:50 +0100 (CET)
Message-ID: <44824.195.55.244.106.1166001170.squirrel@www.arcoscom.com>
References: <54905.84.123.236.132.1165866276.squirrel@www.arcoscom.com>
	<57631.195.55.244.106.1165911878.squirrel@www.arcoscom.com>
	<457E6997.1050001@trash.net>
	<36479.195.55.244.106.1165998665.squirrel@www.arcoscom.com>
	<457FBBFD.6060009@trash.net>
Reply-To: linux@arcoscom.com
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <457FBBFD.6060009@trash.net>
To: lartc@mailman.ds9a.nl,
 netfilter-devel@lists.netfilter.org
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

Then, the actual and updated and maintained substitute for ROUTE is using
CONNMARK and/or MARK and then add filters/rules to routes table with ip.
Am I in the truth?

Sorry for my out-of-date knoledge of these things and for the "obvious"
questions.

Thanks a lot.

El Mie, 13 de Diciembre de 2006, 9:38, Patrick McHardy escribió:
> ArcosCom Linux User wrote:
>> Thanks for your response.
>>
>> I'm using multiple gateways for internet connection and having problems
>> with random disconection, and I not use ROUTE usually, but I was trying
>> to
>> force only one gateway for one type of traffic (which the clients lost
>> conections and are having issues).
>>
>> I know I can use -j MARK or -j CONNMARK and this mark to filter, but I'm
>> using marks for another purposes and I can't use it for routing.
>
> Everything using marks supports bitmasks in 2.6.19.
>
>> The box is a dual xeon and the kernel has been compiled SMP enabled.
>>
>> I haven't tested ROUTE yet with this kernel (2.6.19), but with 2.6.18.x
>> I
>> were having a problem with -j ROUTE in -t mangle and POSTROUTING chain.
>>
>> Perhaps ROUTE need a more in deepth revision?
>
> As I said, it needs to fill in the targetsize field and probably needs
> to adjust the target function signature.
>
>> Do I help more reporting the bug into netfilter-bugzilla?
>
> Its still down, but the ROUTE patch is unmaintained anyway.
>
