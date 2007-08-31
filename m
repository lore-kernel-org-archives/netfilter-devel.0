From: Krzysztof Oledzki <ole@ans.pl>
Subject: Re: /proc/net/ip_conntrack trange behavior
Date: Fri, 31 Aug 2007 17:09:45 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0708311708590.9444@bizon.gios.gov.pl>
References: <46CE8C05.5060202@nj.cpsecure.com>
	<200708290914.l7T9E934019648@toshiba.co.jp>
	<46D5BFB5.6000206@trash.net> <46D61A10.6010405@nj.cpsecure.com>
	<46D66874.1050405@trash.net> <46D6927F.1010406@nj.cpsecure.com>
	<Pine.LNX.4.64.0708311044490.32663@x2>
	<46D7E687.7060404@nj.cpsecure.com>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-128957193-1188572985=:9444"
Cc: netfilter-devel@lists.netfilter.org, Patrick McHardy <kaber@trash.net>
To: Dong_Wei <Dong_Wei@nj.cpsecure.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <46D7E687.7060404@nj.cpsecure.com>
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

  This message is in MIME format.  The first part should be readable text,
  while the remaining parts are likely unreadable without MIME-aware tools.

---187430788-128957193-1188572985=:9444
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Fri, 31 Aug 2007, Dong_Wei wrote:

> Hi Patrick
>
>> On Thu, 30 Aug 2007, Dong_Wei wrote:
>>=20
>>>>> And we can't avoid this issue on 2.4, because no code deal with the=
=20
>>>>> special case.
>>>>=20
>>>>=20
>>>> Thats correct. Is there a problem with this behaviour?
>>>=20
>>> As we know, ip_conntrack has a hash_size to control the ip_conntrack=20
>>> record size. and if tcp in ESTABLISH, and ip_conntrack will keep it for=
 5=20
>>> DAYs.
>>>=20
>>> For exsample, a NAT server can handle 8000 connections, and if sometime=
,=20
>>> NAT server need reboot(6000 conntrack in ESTBLISHED state now). Also we=
=20
>>> set ip_conntrack allowing pickup ESTABLISHED tcp connection, when NAT=
=20
>>> server available again, ip_conntrack will take 6000 conntracks for the=
=20
>>> original connections. but actully these connections are INVALID for the=
=20
>>> web server, because the source ip is the private IPs,such as 192.168.0.=
1.=20
>>> and web server will not answer the client's request. But still the NAT=
=20
>>> server will keep the 6000 conntrack for 5 DAYs. And just 2000 conntrack=
s=20
>>> can be used for the clients. If more than 2000 client want connect to s=
ome=20
>>> websites, some ip_conntrack will be droped.
>>=20
>>=20
>> You can drop ACK packets in state NEW to avoid connection pickup.
> That's a good idea, I will make a patch for my own 2.4 Linux NAT server,=
=20
> thanks a lot :-)

No need to, as all you should do is a proper iptables rule.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki
---187430788-128957193-1188572985=:9444--
