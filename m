From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] net/netfilter/nf_conntrack_proto_sctp.c:206:
 undefined	reference to `local_bh_disable'
Date: Mon, 10 Jul 2006 11:24:48 +0200
Message-ID: <44B21CE0.80202@trash.net>
References: <200607101113.53667.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable
Cc: netfilter@lists.netfilter.org, coreteam@netfilter.org,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-15?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
In-Reply-To: <200607101113.53667.toralf.foerster@gmx.de>
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

Toralf F=F6rster wrote:
> Playing with various configs I got:
>=20
> net/built-in.o: In function `sctp_print_conntrack':
> net/netfilter/nf_conntrack_proto_sctp.c:206: undefined reference to `lo=
cal_bh_disable'
> net/built-in.o: In function `sctp_packet':
> net/netfilter/nf_conntrack_proto_sctp.c:356: undefined reference to `lo=
cal_bh_disable'
> make: *** [.tmp_vmlinux1] Error 1

Should be already fixed in current -git.
