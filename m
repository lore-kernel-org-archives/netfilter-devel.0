From: Bart De Schuymer <bdschuym@pandora.be>
Subject: [RFC] let arptables see bridged frames
Date: Wed, 11 Jun 2003 21:28:39 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200306112128.39326.bdschuym@pandora.be>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: David S.Miller <davem@redhat.com>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I'm planning on letting arptables see bridged frames. This would be done =
by=20
making a new arptables hook "NF_ARP_FORWARD", which would be called insid=
e=20
net/bridge/br_netfilter.c. Next would be adding an arptables target that =
can=20
alter device and IP addresses inside the ARP payload. This can atleast be=
=20
handy on a bridging firewall. Since there's no real routing or bridging=20
happening for the ARP prococol, I don't think there's any need for specia=
l=20
chains to alter the payload: just allow it in all three arptables chains.

Are there any objections against this, or comments? This would be only fo=
r=20
2.5/2.6. Maybe it's too late into 2.5 for this? There's now an arptables=20
userspace tool, so that's not a problem.

cheers,
Bart
