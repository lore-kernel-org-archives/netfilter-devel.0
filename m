From: "Alexander Stieglecker" <a.stieglecker@gmx.net>
Subject: ICMP error handling in CLUSTERIP
Date: Wed, 6 Apr 2005 11:41:39 +0200
Message-ID: <000001c53a8c$d5910290$aa28abc1@Vagabond>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
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

Hi,=20

when I browsed through the CLUSTERIP target function I discovered the
following pice of code:

/* special case: ICMP error handling. conntrack distinguishes between
 * error messages (RELATED) and information requests (see below) */
if ((*pskb)->nh.iph->protocol =3D=3D IPPROTO_ICMP
    && (ctinfo =3D=3D IP_CT_RELATED=20
	|| ctinfo =3D=3D IP_CT_IS_REPLY+IP_CT_IS_REPLY))
	return IPT_CONTINUE;

IP_CT_IS_REPLY+IP_CT_IS_REPLY equals six which is greater than =
IP_CT_NUMBER.
Shouldn't it be something like IP_CT_IS_RELATED+IP_CT_IS_REPLY?
