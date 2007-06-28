From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipt_account / iptables 1.3.8
Date: Thu, 28 Jun 2007 13:29:29 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0706281327000.28886@blackhole.kfki.hu>
References: <1182962627.16585.6.camel@localhost>
	<4682A981.3090608@plouf.fr.eu.org> <4682ACE2.8020606@blue-labs.org>
	<Pine.LNX.4.64.0706272059590.11120@fbirervta.pbzchgretzou.qr>
	<4682BCF9.6040100@trash.net>
	<Pine.LNX.4.64.0706272145220.11120@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0706280007080.28193@blackhole.kfki.hu>
	<4682F677.7010503@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4682F677.7010503@trash.net>
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

On Thu, 28 Jun 2007, Patrick McHardy wrote:

>> I'd like to see an IPv4/IPv6 compatible TARPIT module in the mainline
>> kernel. But please extend the target so that it could be used from the
>> raw table and let the reply packets skip conntrack. Thus we could
>> benefit from TARPIT even in a full blown conntrack/nat setup as well.
>> (If I recall correctly, that is not possible with the original version.)
>
> The easiest way to do this would probably be to optionally attach
> a notrack conntrack to new packets.

Yes, exactly.

> Looking at the version in SVN, it also needs:
[...]
> Shouldn't be much work, maybe I'll look into this after finishing
> my conntrack hash patches if no one beats me to it.

The amount of work you have been doing is simply amazing...

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
