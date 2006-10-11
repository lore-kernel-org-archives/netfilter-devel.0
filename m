From: Patrick McHardy <kaber@trash.net>
Subject: Re: [netfilter-core] linux-2.6.19-rc1 (commit ebf7a227) build failed
Date: Wed, 11 Oct 2006 10:41:35 +0200
Message-ID: <452CAE3F.7040608@trash.net>
References: <200610110939.28328.toralf.foerster@gmx.de>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="------------030809030707000007010404"
Cc: netfilter@lists.netfilter.org, coreteam@netfilter.org,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: =?ISO-8859-15?Q?Toralf_F=F6rster?= <toralf.foerster@gmx.de>
In-Reply-To: <200610110939.28328.toralf.foerster@gmx.de>
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

This is a multi-part message in MIME format.
--------------030809030707000007010404
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: quoted-printable

Toralf F=F6rster wrote:
> net/built-in.o: In function `xt_connsecmark_init':
> xt_CONNSECMARK.c:(.init.text+0xed4): undefined reference to `need_connt=
rack'
> make: *** [.tmp_vmlinux1] Error 1

Thanks, fixed by this patch.

BTW, please report non-critical bugs to netfilter-devel only.
I know MAINTAINERS says to send them to coreteam@, I'm going
to fix that.


--------------030809030707000007010404
Content-Type: text/plain;
 name="x"
Content-Disposition: inline;
 filename="x"
Content-Transfer-Encoding: quoted-printable

[NETFILTER]: xt_CONNSECMARK: fix Kconfig dependencies

CONNSECMARK needs conntrack, add missing dependency to fix linking error
with CONNSECMARK=3Dy and CONNTRACK=3Dm.

Reported by Toralf F=F6rster <toralf.foerster@gmx.de>.

Signed-off-by: Patrick McHardy <kaber@trash.net>

---
commit 0ab5046ab83e4f0e88c40922701b2bc365f6aa09
tree 4add4ff88904c63e7ff20872f2faff015bbcbc28
parent 889d786a9211434b29e402a501d01a590b072d31
author Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 10:39:47 +0200
committer Patrick McHardy <kaber@trash.net> Wed, 11 Oct 2006 10:39:47 +02=
00

 net/netfilter/Kconfig |    4 +++-
 1 files changed, 3 insertions(+), 1 deletions(-)

diff --git a/net/netfilter/Kconfig b/net/netfilter/Kconfig
index ce94732..f619c65 100644
--- a/net/netfilter/Kconfig
+++ b/net/netfilter/Kconfig
@@ -209,7 +209,9 @@ config NETFILTER_XT_TARGET_SECMARK
=20
 config NETFILTER_XT_TARGET_CONNSECMARK
 	tristate '"CONNSECMARK" target support'
-	depends on NETFILTER_XTABLES && (NF_CONNTRACK_SECMARK || IP_NF_CONNTRAC=
K_SECMARK)
+	depends on NETFILTER_XTABLES && \
+		   ((NF_CONNTRACK && NF_CONNTRACK_SECMARK) || \
+		    (IP_NF_CONNTRACK && IP_NF_CONNTRACK_SECMARK))
 	help
 	  The CONNSECMARK target copies security markings from packets
 	  to connections, and restores security markings from connections

--------------030809030707000007010404--
