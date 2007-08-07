From: Pascal Hambourg <pascal.mail@plouf.fr.eu.org>
Subject: Re: conntrack clarification
Date: Tue, 07 Aug 2007 11:42:04 +0200
Message-ID: <46B83E6C.6070906@plouf.fr.eu.org>
References: <29656818.1521186459222779.JavaMail.root@localhost>
	<4618641.2011186474076639.JavaMail.root@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: quoted-printable
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <4618641.2011186474076639.JavaMail.root@localhost>
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

Andrew Hall a =E9crit :
>=20
> I now realize that it is the return TCP
> traffic that is keeping the conntrack populated.

I think this should not happen any more if you disable the TCP=20
connection pickup (/proc/sys/net/netfilter/nf_conntrack_tcp_loose=3D0), o=
r=20
drop INVALID packets in the return direction (in the OUTPUT chain, IIUC).
