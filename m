From: zhongyu <zhongyu@18mail.cn>
Subject: Re: [MATCH] a match for qq
Date: Sat, 22 Jul 2006 10:20:16 +0800
Message-ID: <1153534816.3602.3.camel@localhost.localdomain>
References: <1153176704.15818.1.camel@localhost.localdomain>
	<44BFAEA4.5070507@trash.net>
	<1153366270.24974.7.camel@localhost.localdomain>
	<44C0144A.6060604@trash.net>
Reply-To: zhongyu@18mail.cn
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>,
	netfilter dev <netfilter-devel@lists.netfilter.org>
In-Reply-To: <44C0144A.6060604@trash.net>
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

I setup a repository
http://218.241.65.3:8080/svn
Is it ok?
MSN and QQ are still in the same match now, I will seperate them if
there are too many functions :-)

2006-07-21 01:39 +0200=EF=BC=8CPatrick McHardy=EF=BC=9A
> zhongyu wrote:
> > Ofcause, and I had added the msn support for this match, so the modul=
e
> > name was changed to ipt_im. I will search the STL protocol and add th=
e
> > GoogleTalk support soon (my current idea is match the STL
> > certifacation's common name).
> > The new code is here
> > http://www.18mail.cn/ipt_im.tgz
>=20
> You need to publish an index file for a pomng repository.
>=20
> Check out one of the existing repositories for examples:
>=20
> # geoip, maintained by Samuel Jean <jix@bugmachine.ca>
> http://mynodes.net/pub/linux/netfilter/patchlets
>=20
> # condition, maintained by Massimiliano Hofer <max@nucleus.it>
> http://www.nucleus.it/pom-repo
>=20
> # ipp2p and time maintained by Krzysztof Oledzki <ole@ans.pl>
> http://people.netfilter.org/ole/pom/
>=20
