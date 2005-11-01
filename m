From: Krzysztof Oledzki <olenf@ans.pl>
Subject: Re: problem with conntrack utility and kernel 2.6.14
Date: Tue, 1 Nov 2005 21:21:10 +0100 (CET)
Message-ID: <Pine.LNX.4.63.0511012118270.21639@bizon.gios.gov.pl>
References: <4361EAAB.1090206@fliegl.de> <4361F6DF.3050106@eurodev.net>
	<43621028.40705@fliegl.de> <43627A8F.9060307@eurodev.net>
	<436281BB.2010100@fliegl.de>
	<436373E8.7040606@eurodev.net> <436398C7.4070402@fliegl.de>
	<4365A097.1080001@eurodev.net>
	<Pine.LNX.4.62.0510310911090.9468@bizon.gios.gov.pl>
	<4366C031.6020504@eurodev.net>
	<Pine.LNX.4.63.0511011116550.3512@bizon.gios.gov.pl>
	<436773EB.6000608@eurodev.net>
	<Pine.LNX.4.63.0511011605010.12220@bizon.gios.gov.pl>
	<43679A3B.6070009@eurodev.net>
	<Pine.LNX.4.63.0511011747370.15256@bizon.gios.gov.pl>
	<4367CB1E.8080407@eurodev.net>
Mime-Version: 1.0
Content-Type: MULTIPART/MIXED;
	BOUNDARY="-187430788-1097087602-1130876470=:21639"
Cc: Deti Fliegl <deti@fliegl.de>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4367CB1E.8080407@eurodev.net>
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

---187430788-1097087602-1130876470=:21639
Content-Type: TEXT/PLAIN; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: QUOTED-PRINTABLE



On Tue, 1 Nov 2005, Pablo Neira wrote:

> Krzysztof Oledzki wrote:
>>> That is what it currently does, are you observing a different behaviour=
?
>>=20
>> Unfortunately :(
>>=20
>>> # conntrack -D --orig-src 1.1.1.1 --orig-dst 2.2.2.2 -p tcp=20
>>> --orig-port-src 2005 --orig-port-dst 21
>>> NFNETLINK answers: No such file or directory
>>> Operation failed: such conntrack doesn't exist
>>=20
>> # conntrack -L -i|grep 192.168.130.123
>> udp      17 20 src=3D192.168.0.33 dst=3D192.168.130.123 sport=3D123 dpor=
t=3D123=20
>> packets=3D1 bytes=3D76 src=3D192.168.130.123 dst=3D192.168.0.33 sport=3D=
123 dport=3D123=20
>> packets=3D1 bytes=3D76 mark=3D0 use=3D1 id=3D13157
>>=20
>> root@olemx:~# conntrack -D --orig-src 192.168.0.33 --orig-dst=20
>> 192.168.130.123 -p udp --orig-port-src 123 --orig-port-dst 123 -i 90909
>
> Fixed in SVN.
>
>> # conntrack -L -i|grep 192.168.130.123
>> (empty)
>>=20
>> # conntrack -D --orig-src 192.168.0.33 --orig-dst 192.168.130.123 -p udp=
=20
>> --orig-port-src 123 --orig-port-dst 123 -i 90909
>> NFNETLINK answers: No such file or directory
>> Operation failed: sorry, you must be root or get CAP_NET_ADMIN capabilit=
y=20
>> to do this
>
> This error message is related with libnfnetlink, give a try to the patch=
=20
> attached. It fixes it. I'll pass it to Harald.

Both problems are now fixed. Thank you.

Best regards,

 =09=09=09=09Krzysztof Ol=EAdzki

PS: libnfnetlink still has aclocal-1.6 & automake-1.6 in autogen.sh.
---187430788-1097087602-1130876470=:21639--
