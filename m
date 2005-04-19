From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: nfnetlink/ctnetlink - OOPS&panic
Date: Tue, 19 Apr 2005 15:39:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.62.0504191531390.2730@bizon.gios.gov.pl>
References: <Pine.LNX.4.62.0504191220390.27543@bizon.gios.gov.pl>
	<4264F3B6.9010408@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED; BOUNDARY="-187430788-12337631-1113917949=:2730"
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4264F3B6.9010408@eurodev.net>
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

---187430788-12337631-1113917949=:2730
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 19 Apr 2005, Pablo Neira wrote:

> Krzysztof Oledzki wrote:
>> Hello,
>>=20
>> I have just compiled 2.6.11.7 kernel with nfnetlink/ctnetlink support (f=
rom=20
>> pom-ng-20050418). Unfortunately, during system startup, kernel panics:
>>=20
>> Unable to handle kernel NULL pointer dereference at virtual address=20
>> 000000b3
>>  printing eip:
>> *pde =3D 00000000
>> Oops: 0000 [#1]
>> PREEMPT
>> Modules linked in: bonding
>
> You've catch a race condition.
>
> Since you've compiled nfnetlink and ctnetlink in kernel, not as module, i=
t=20
> seems that ctnetlink registers the subsystem via nfnetlink_subsys_registe=
r=20
> before nfnetlink has created the netlink socket. Then you've received an=
=20
> event that has been sent to a non-existing netlink socket. I can cook an =
oops=20
> with that.
>
> I'll fix it as soon as I get some spare time.

OK. So I have just checked modular configuration (CONFIG_IP_NF_CONNTRACK_NE=
TLINK=3Dm & CONFIG_NETFILTER_NETLINK=3Dm)

# modprobe nfnetlink
FATAL: Error inserting nfnetlink (/lib/modules/2.6.11.7/kernel/net/netfilte=
r/nfnetlink.ko): Operation not permitted

dmesg shows:
Netfilter messages via NETLINK v0.12.
cannot initialize nfnetlink!


# modprobe ip_conntrack_netlink
WARNING: Error inserting nfnetlink (/lib/modules/2.6.11.7/kernel/net/netfil=
ter/nfnetlink.ko): Operation not permitted
FATAL: Error inserting ip_conntrack_netlink (/lib/modules/2.6.11.7/kernel/n=
et/ipv4/netfilter/ip_conntrack_netlink.ko): Unknown symbol in module, or un=
known parameter (see dmesg)

dmesg shows:
ip_conntrack_netlink: Unknown symbol __nfa_fill
ip_conntrack_netlink: Unknown symbol nfnetlink_subsys_register
ip_conntrack_netlink: Unknown symbol nfnetlink_subsys_alloc
ip_conntrack_netlink: Unknown symbol nfnetlink_send
ip_conntrack_netlink: Unknown symbol nfnetlink_subsys_unregister
ip_conntrack_netlink: Unknown symbol nfnetlink_check_attributes

Hm... Did I forget about something obvious?

Best regards,

 =09=09=09Krzysztof Ol=EAdzki
---187430788-12337631-1113917949=:2730--
