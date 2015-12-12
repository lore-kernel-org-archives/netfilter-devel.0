From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Linux 4.3.1 regression: -m state returns "Protocol wrong type
 for socket"
Date: Sat, 12 Dec 2015 20:32:37 +0100
Message-ID: <20151212193237.GB10759@salvia>
References: <n4g4s8$4pr$1@ger.gmane.org>
 <566BEF33.7090501@gmail.com>
 <alpine.DEB.2.10.1512121116390.13421@blackhole.kfki.hu>
 <566C09F5.6080606@gmail.com>
 <alpine.DEB.2.10.1512121259340.14295@blackhole.kfki.hu>
 <566C0E75.6080800@familie-kuntze.de>
 <566c4622.936d810a.ece67.ffffdfc9@mx.google.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="DocE+STaALJfprDB"
Content-Transfer-Encoding: 8bit
Cc: Noel Kuntze <noel@familie-kuntze.de>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Remzi =?iso-8859-1?Q?AKY=DCZ?= <linuxliste@gmail.com>,
	netfilter@vger.kernel.org, netfilter-devel@vger.kernel.org
To: =?iso-8859-1?Q?D=E2niel?= Fraga <fragabr@gmail.com>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <566c4622.936d810a.ece67.ffffdfc9@mx.google.com>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


--DocE+STaALJfprDB
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit

On Sat, Dec 12, 2015 at 02:06:55PM -0200, Dâniel Fraga wrote:
> 	I tried this:
> 
> iptables -A INPUT -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
> 
> 	And I got the same error:
> 
> iptables: Protocol wrong type for socket.

There is some problem with the revision infrastructure.

iptables is asking for a match revision that is not available in the
kernel. So the negotiation between userspace and kernel to use a given
version of this match is failing for some reason.

Could you apply this patch and tell me what it shows when you run this
command and the one using -m state?

BTW, any particularly on your setup that is worth mention?

Thanks.

--DocE+STaALJfprDB
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="x.patch"

diff --git a/libxtables/xtables.c b/libxtables/xtables.c
index f14d503..d0e942c 100644
--- a/libxtables/xtables.c
+++ b/libxtables/xtables.c
@@ -825,6 +825,8 @@ int xtables_compatible_revision(const char *name, uint8_t revision, int opt)
 
 static int compatible_match_revision(const char *name, uint8_t revision)
 {
+	printf("compatible_match_revision name=%s revision=%u\n",
+		name, revision);
 	return xt_params->compat_rev(name, revision, afinfo->so_rev_match);
 }
 

--DocE+STaALJfprDB--
