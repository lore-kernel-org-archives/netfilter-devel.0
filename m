From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: Call for testing: patch-o-matic-ng
Date: Mon, 22 Dec 2003 10:56:26 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1072086985.1031.7.camel@nienna.balabit>
References: <20031221122445.GC5058@obroa-skai.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-BFNFXJX/ctnSZIed6unh"
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Netfilter Mailinglist <netfilter@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20031221122445.GC5058@obroa-skai.de.gnumonks.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-BFNFXJX/ctnSZIed6unh
Content-Type: text/plain; charset=ISO-8859-2
Content-Transfer-Encoding: 8bit


  Hi,

2003-12-21, v keltezéssel 13:24-kor Harald Welte ezt írta:
> I would like to have people start testing/using pom-ng and report errors
> back to me (via email).

  I've tried it, and had some problems with it. Namely, the following
error message (Debian woody and sid, perl 5.6.1 and 5.8.2):

hidden@big:~/patch-o-matic-ng$ ./runme 
Examining kernel in /usr/src/linux-2.4.22-tproxy113
Can't bless non-reference value at /usr/share/perl/5.6.1/Term/Cap.pm line 136.

  The patch attached fixed the problem.

-- 
 Regards,
   Krisztian KOVACS

--=-BFNFXJX/ctnSZIed6unh
Content-Disposition: attachment; filename=tgetent.diff
Content-Type: text/x-patch; name=tgetent.diff; charset=ISO-8859-2
Content-Transfer-Encoding: 7bit

Index: runme
===================================================================
RCS file: /cvspublic/netfilter/patch-o-matic-ng/runme,v
retrieving revision 1.7
diff -u -r1.7 runme
--- runme	21 Dec 2003 19:03:23 -0000	1.7
+++ runme	22 Dec 2003 09:47:15 -0000
@@ -201,7 +201,7 @@
 }
 
 if (defined($ENV{TERM})) {
-	my $terminal = Term::Cap->Tgetent();
+	my $terminal = Tgetent Term::Cap {};
 	$clrscr = $terminal->Tputs('cl', 1);
 }
 

--=-BFNFXJX/ctnSZIed6unh--
