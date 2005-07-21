From: Eric Leblond <eric@inl.fr>
Subject: Re: ip_queue freeze with 2.6.9 RHEL4
Date: Thu, 21 Jul 2005 09:39:43 +0200
Message-ID: <1121931584.5535.3.camel@localhost.localdomain>
References: <1121891748.16195.25.camel@localhost.localdomain>
	<42DEC52F.2020500@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: quoted-printable
Cc: netfilter-devel@lists.netfilter.org, redhat-list@redhat.com
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <42DEC52F.2020500@trash.net>
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

Le mercredi 20 juillet 2005 =E0 23:42 +0200, Patrick McHardy a =E9crit :
> Eric Leblond wrote:
> > Is there known issues on some systems with 2.6.9 and ip_queue ? or is i=
t
> > a RedHat problem ?
>=20
> In which hook are you queueing packets?=20

I've got one rule only :
	iptables -A INPUT -p tcp --dport 22 --syn -j ACCEPT

Same "ruleset" works correctly with test done with RHEL3 the same day
(almost same hardware)=20

> Does it freeze immediately, or
> do you need to reinject the packet first?

It freezes just after I send the NF_ACCEPT decision.

BR,
--=20
Eric Leblond <eric@inl.fr>
