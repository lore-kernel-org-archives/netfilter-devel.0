From: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Subject: Re: Problem accessing https://my.procurve.com/profile/index.aspx
 (ACK is over the upper bound)
Date: Mon, 2 Jul 2007 15:42:06 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707021537390.32643@blackhole.kfki.hu>
References: <Pine.LNX.4.64.0707010207490.13212@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707010255010.13212@bizon.gios.gov.pl>
	<4688FC41.5070403@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4688FC41.5070403@trash.net>
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

> Krzysztof Oledzki wrote:
>>
>> OK, this was easy. The RST was sent simply because the packed was not
>> dropped but instead delivered to the local IP - there was no valid tuple
>> to change (unnat) the packed destination. Setting:
>>
>> iptables -I PREROUTING -m conntrack --ctstate INVALID -j DROP
>
> We should really document that with window tracking and NAT you
> must drop INVALID packets to avoid them getting delivered locally
> and causing a RST.

Couldn't we do it in NAT itself? I.e drop the packet by NAT if 
ip_conntrack_tcp_be_liberal is unset and the packet is INVALID.

It'd be backward-incompatible as it'd change the current behaviour but 
were more safer (saner) than the present approach.

Best regards,
Jozsef
-
E-mail  : kadlec@blackhole.kfki.hu, kadlec@sunserv.kfki.hu
PGP key : http://www.kfki.hu/~kadlec/pgp_public_key.txt
Address : KFKI Research Institute for Particle and Nuclear Physics
           H-1525 Budapest 114, POB. 49, Hungary
