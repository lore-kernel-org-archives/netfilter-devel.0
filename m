From: "chuanbo zheng" <zhengcb@netpower.com.cn>
Subject: about the tcp connection state
Date: Sun, 15 Feb 2004 18:51:26 +0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040215183662.SM00868@guozheng>
Mime-Version: 1.0
Content-Type: text/plain;
      charset="GB2312"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


In ip_conntrack_proto_tcp.c=3D=3D>tcp_new()=A3=ACthe newconntrack is set=
 to,
 =09newconntrack
=09=09=3D tcp_conntracks[0][get_conntrack_index(tcph)]
=09=09[TCP_CONNTRACK_NONE];
I noticed in the difination of tcp_conntracks,=
 tcp_conntracks[0][2][TCP_CONNTRACK_NONE]
will be TCP_CONNTRACK_ESTABLISHED. then when an ACK packet=
 without SYN is received by
netfilter, the state would be directly changed to ESTABLISHED. Is=
 there reason for doing
like this? or I made some mistake.

thanks.

regards,
Jack
zhengcb@netpower.com.cn
