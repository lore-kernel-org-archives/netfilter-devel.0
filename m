From: Eric Leblond <eric@regit.org>
Subject: Re: CONNMARK and state RELATED
Date: Wed, 03 Mar 2004 08:04:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1078297483.1447.3.camel@localhost>
References: <7C9884991ADAE0479C14F10C858BCDF56791B5@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=
Content-Transfer-Encoding: quoted-printable
Cc: Netfilter developmnet mailing list <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Daniel Chemko <dchemko@smgtec.com>
In-Reply-To: <7C9884991ADAE0479C14F10C858BCDF56791B5@alderaan.smgtec.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Le mer 03/03/2004 =C3=A0 01:53, Daniel Chemko a =C3=A9crit :
> Does anyone know if these two technologies are compatible?

I think so, I've deployed this to do the same as you and it works fine
(even with FTP)

> My rules are as follows:
> ${IPTABLES} -t mangle -A PREROUTING --source ${_fip} --destination
> ${_sip} -p ${_proto} -j CONNMARK --set-mark ${_fwmark} -m mark --mark 0
>=20

Have you try as show at :
	http://hom.regit.org/connmark.html
(You need to restore the mark.)

BR,
--
Eric Leblond
