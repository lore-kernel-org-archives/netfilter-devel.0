From: Kovacs Krisztian <piglet@sch.bme.hu>
Subject: nf/ctnetlink and notify
Date: Mon, 20 Jan 2003 18:11:29 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030120171129.GB27847@sch.bme.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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

  I'd have a question regarding the nfnetlink/ctnetlink patch in the
'extra' suite of POM. In this version of nfnetlink, the notify callback
API is missing (ip_conntrack_notify_register() and friends), while in the
old version in the oldnat directory it is part of the ctnetlink patch. Wh=
y
was this left out of the patch? What are the main concerns with the
_notify() code in the old patch?
  As I can see some kind of such notification service will be required to
complete the nfnetlink patch, because in its current state it's totally
uncapable of sending messages on conntrack state changes. (And one
possible typo in the patch: in nfnetlink_conntrack.c ctnetlink_create is
not commented out, but there is no use of this function.)

--=20
 Kov=E1cs Kriszti=E1n
