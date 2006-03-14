From: Chinh Nguyen <cnguyen@certicom.com>
Subject: Re: ip6tables: Unknown error 4294967295
Date: Tue, 14 Mar 2006 09:54:39 -0500
Message-ID: <4416D92F.40103@certicom.com>
References: <342126766.19325@ustc.edu.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: GuanYao Huang <gyhuang@mail.ustc.edu.cn>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <342126766.19325@ustc.edu.cn>
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


net/ipv4/netfilter is a directory in the kernel source code. I took a quick=
 peek
at the latest kernel 2.6.16-rc6. I don't think there's any support for the
"ROUTE" target in the kernel.

Can any netfilter developer confirm?


GuanYao Huang wrote:
> Hi, I have no net/ipv4/netfilter/ directory.
> I am using FC4, iptables-1.3.5. Initially, iptables-1.3.5 does not suppor=
t ROUTE
> module, which is an extension.
> There is libip6t=5FROUTE.c in PWD/extension directory, but it is not comp=
iled. So I
> changed the makefile to include it and add some source code to libip6t=5F=
ROUTE.c
> which should be the header file for some definitions. That's all I have d=
one.
> I don't know if there is something else I should do.
> Thanks.
>=20
> =D4=DA=C4=FA=B5=C4=C0=B4=D0=C5=D6=D0=D4=F8=BE=AD=CC=E1=B5=BD:
>=20
>>From: Chinh Nguyen <cnguyen@certicom.com>
>>Reply-To:=20
>>To: netfilter-devel@lists.netfilter.org
>>Subject: Re: ip6tables: Unknown error 4294967295
>>Date:Fri, 10 Mar 2006 09:57:11 -0500
>>
>>GuanYao Huang wrote:
>>
>>>Hi:
>>>I am doing research into iptables-1.3.5, in which I am trying to use ROU=
TE
>=20
> target
>=20
>>>which is an extension to the current iptables.=20
>>>I added libip6t=5FROUTE.h which makes libip6t=5FROUTE.c complied.
>>>When using the following command:
>>>[root@localhost iptables]# /root/CNGI/iptables-1.3.5/ip6tables -A POSTRO=
UTING
>=20
> -t
>=20
>>>mangle -o eth0 -p tcp --dport 22 -j ROUTE --oif iptun
>>>ip6tables: Unknown error 4294967295
>>>
>>>I don't know why. Can you help me? Thanks.
>>>
>>>
>>>
>>
>>There are 2 parts to netfilter. The modules that are used by iptables to =
parse
>>arguments and communicate them to the kernel and the kernel modules that =
are
>>loaded (or compiled in) with the kernel.
>>
>>One problem could be that your current kernel does not have support for t=
he
>>netfilter module you are trying to used.
>>
>>I have often seen this error associated with an 'invalid argument' return=
ed by
>>the netfilter kernel module. In previous versions of iptables, it will say
>>'invalid argument' instead of 'Unknown error 4294967295'.
>>
>>This is typically caused by an invalid or missing condition causing the
>>netfilter kernel to reject the rule in its checkentry function.
>>
>>Unfortunately, sometimes all the necessary valid conditions are not enume=
rated
>>in any iptables manual or checked by the iptables module.
>>
>>For example, consider this
>> /opt/iptables-1.3.5/bin/iptables -A OUTPUT -m esp --espspi ! 0 -j LOG
>>iptables: Unknown error 4294967295
>>
>>What is not known is that you have to specify '-p esp' if you will to use
>=20
> module
>=20
>>'esp', which becomes apparent if you look at the kernel source code:
>>
>>net/ipv4/netfilter/ipt=5Fesp.c:
>>static int
>>checkentry(const char *tablename,
>>       const void *ip=5Fvoid,
>>       void *matchinfo,
>>       unsigned int matchinfosize,
>>       unsigned int hook=5Fmask)
>>{
>>    const struct ipt=5Fesp *espinfo =3D matchinfo;
>>    const struct ipt=5Fip *ip =3D ip=5Fvoid;
>>
>>    /* Must specify proto =3D=3D ESP, and no unknown invflags */
>>    if (ip->proto !=3D IPPROTO=5FESP || (ip->invflags & IPT=5FINV=5FPROTO=
)) {
>>        duprintf("ipt=5Fesp: Protocol %u !=3D %u\n", ip->proto,
>>             IPPROTO=5FESP);
>>        return 0;
>>    }
>>
>>If this is your problem, you might have to do some source code reading :)
>>
>>
>=20
>=20
>=20
