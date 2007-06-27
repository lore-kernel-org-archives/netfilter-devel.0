From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipt_account / iptables 1.3.8
Date: Thu, 28 Jun 2007 01:44:55 +0200
Message-ID: <4682F677.7010503@trash.net>
References: <1182962627.16585.6.camel@localhost>	<4682A981.3090608@plouf.fr.eu.org>
	<4682ACE2.8020606@blue-labs.org>	<Pine.LNX.4.64.0706272059590.11120@fbirervta.pbzchgretzou.qr>	<4682BCF9.6040100@trash.net>	<Pine.LNX.4.64.0706272145220.11120@fbirervta.pbzchgretzou.qr>
	<Pine.LNX.4.64.0706280007080.28193@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0706280007080.28193@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> On Wed, 27 Jun 2007, Jan Engelhardt wrote:
> 
>> Can I also submit a (hopefully cleaned) e.g. TARPIT?
> 
> 
> I'd like to see an IPv4/IPv6 compatible TARPIT module in the mainline
> kernel. But please extend the target so that it could be used from the
> raw table and let the reply packets skip conntrack. Thus we could
> benefit from TARPIT even in a full blown conntrack/nat setup as well.
> (If I recall correctly, that is not possible with the original version.)

The easiest way to do this would probably be to optionally attach
a notrack conntrack to new packets. Looking at the version in SVN,
it also needs:

- use generic checks for table and hook validation
- remove impossible skb->dst NULL ptr check
- remove impossible check for PACKET_OTHERHOST
- not abuse xrlim_allow
- resync TCP packet generation code with ipt_REJECT, especially
  properly deal with IPsec, not use ip_direct_send but dst_output
- kill ip_direct_send
- kill obsolete ifdefs

Shouldn't be much work, maybe I'll look into this after finishing
my conntrack hash patches if no one beats me to it.
