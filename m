From: Tim Gardner <timg@tpi.com>
Subject: [patch-o-matic-ng] raw
Date: Fri, 16 Jan 2004 15:20:27 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200401161520.27405.timg@tpi.com>
Reply-To: timg@tpi.com
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Harald,

Please add to raw/linux/net/ipv4/netfilter/Makefile.ladd:

obj-$(CONFIG_IP_NF_RAW) +=3D iptable_raw.o

rtg
--=20
Tim Gardner - timg@tpi.com
www.tpi.com 406-443-5357
