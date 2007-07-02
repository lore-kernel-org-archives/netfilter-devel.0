From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Problem accessing https://my.procurve.com/profile/index.aspx
 (ACK is over the upper bound)
Date: Mon, 2 Jul 2007 16:58:33 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707021652260.32643@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>
	<4688FC41.5070403@trash.net>
	<Pine.LNX.4.64.0707021537390.32643@blackhole.kfki.hu>
	<46890846.90907@trash.net>
	<Pine.LNX.4.64.0707021622320.32643@blackhole.kfki.hu>
	<46890FC0.9050903@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46890FC0.9050903@trash.net>
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

On Mon, 2 Jul 2007, Patrick McHardy wrote:

>>> I'm a bit sceptical about NAT core caring about TCP conntrack
>>> specific sysctls, I'd prefer an unconditional drop.
>>
>> NAT works on top of conntrack so peeking the flags were not completely
>> perverse ;-). If NAT drops INVALID packets undconditionally, that'd
>> disable the sysctl flag completely and we had to say "this sysctl
>> setting cannot be used if the NAT module is loaded in".
>
> Would it really? The sysctls flag makes *more* packets be regarded
> as valid, so I'm not I'm following ..

You are right, sigh, I wrote rubbish.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
