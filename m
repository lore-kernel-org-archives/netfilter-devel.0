From: "Vishwas Manral" <Vishwas@sinett.com>
Subject: LAND check: 2.4.20
Date: Mon, 14 Mar 2005 03:41:36 -0800
Message-ID: <BB6D74C75CC76A419B6D6FA7C38317B26A25DC@sinett-sbs.SiNett.LAN>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="US-ASCII"
Content-Transfer-Encoding: quoted-printable
Content-class: urn:content-classes:message
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

Hi folks,

I found no check in the iptables module for LAND attack source
port/ipAddr =3D=3D destination port/ipAddr.
http://www.cert.org/advisories/CA-1997-28.html

Would we want to add that in ipt_unclean.c in the functions check_tcp
and check_udp?

Thanks,
Vishwas
