From: "zze-Proxy_Corveller ball001 exterieur FTRD" <proxycorveller.ball001@rd.francetelecom.com>
Subject: Problem in NAT table at PREROUTING with VLAN
Date: Fri, 25 Apr 2003 10:10:08 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <8C19E3FBB6467846AFF97E366D34CB6055A022@lanmhs20.rd.francetelecom.fr>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm trying to catch packets coming from VLANs (by using vconfig) at
PREROUTING.=20
The mangle table sees VLANs packets but not the NAT table.=20

I've tried different targets such as the incoming interface or the
destination address,=20
at each time the mangle table see packets but not the NAT table.

Is it normal ?

Mickael
