From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: ipset merge
Date: Sat, 11 Aug 2007 16:40:20 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708111626390.17495@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0708011057060.26668@fbirervta.pbzchgretzou.qr>
	<46B04D3B.6090706@netfilter.org>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Jan Engelhardt <jengelh@computergmbh.de>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46B04D3B.6090706@netfilter.org>
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

Hi,

On Wed, 1 Aug 2007, Pablo Neira Ayuso wrote:

> Jan Engelhardt wrote:
>> I was wondering whether there are any obstacles to merge ipset into
>> mainline - for example, it being too much of a hack like ipt_ROUTE was.
>> Otherwise, I'd like to prepare and submit it.
>
> It must use the new nfnetlink infrastructure.

Yes, exactly. But besides the netlink infrastructure it must also support 
IPv6, before thinking on merging. The main modifications in ipset I'm 
planning and working are

- use netlink instead of sockopt
- support IPv6
- throw away binding of sets (the hackish part of ipset), which is
   complex and not efficient enough
- add new set types as a substitute of the purged out bindings
- throw away 'iptree' type which is somewhat a fiasco :-(
- add 'timeout' support to all set types
- add a 'union' type to make life even more easier :-)

> Jozsef is currently working on that.

Yep, slower than I hoped :-(.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
