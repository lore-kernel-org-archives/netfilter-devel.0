From: "Filip Sneppe (Cronos)" <filip.sneppe@cronos.be>
Subject: [PATCH] Re: RV: Problems installing Netfilter extensions
Date: 20 Jun 2003 11:36:32 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1056101793.633.15.camel@exile>
References: <000901c336e7$bb9b5390$0300000a@juan>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="=-Mz4opHtNIWjgyC6y9Vr8"
Cc: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Juan Torres <islero77@telefonica.net>
In-Reply-To: <000901c336e7$bb9b5390$0300000a@juan>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


--=-Mz4opHtNIWjgyC6y9Vr8
Content-Type: text/plain
Content-Transfer-Encoding: 7bit

On Fri, 2003-06-20 at 06:52, Juan Torres wrote:

> 			# make all install
> 
> 	This last step doesn't work!! When I execute this command in the
> userspace/ subdirectory inside the patch-o-matic directory, It appears
> an error saying that It can't find the "all" option (or something
> similar), I have proved to do "make all" and "make install", but it
> doesn't work anyway
> 
> 
> 	What I'm not doing properly??
> 
Hi Juan,

There appears to be an error in the Netfilter extensions HOWTO.
As you can see from the INSTALL file in the userspace directory,
there is no "make all", only a "make" to build the binaries.

I think the patch below updates the documentation to reflect
this. Thanks for pointing this out.

Regards,
Filip

--=-Mz4opHtNIWjgyC6y9Vr8
Content-Disposition: attachment; filename=docufix.diff
Content-Transfer-Encoding: quoted-printable
Content-Type: text/x-patch; name=docufix.diff; charset=ANSI_X3.4-1968

diff -urN netfilter/documentation/HOWTO/de/netfilter-extensions-HOWTO.sgml =
netfilter-docfix/documentation/HOWTO/de/netfilter-extensions-HOWTO.sgml
--- netfilter/documentation/HOWTO/de/netfilter-extensions-HOWTO.sgml	2002-1=
0-22 12:15:19.000000000 +0200
+++ netfilter-docfix/documentation/HOWTO/de/netfilter-extensions-HOWTO.sgml=
	2003-06-20 11:28:41.000000000 +0200
@@ -181,7 +181,7 @@
=20
 <tscreen>
 <verb>
-# make all install
+# make; make install
 </verb>
 </tscreen>
=20
diff -urN netfilter/documentation/HOWTO/fr/netfilter-extensions-HOWTO.sgml =
netfilter-docfix/documentation/HOWTO/fr/netfilter-extensions-HOWTO.sgml
--- netfilter/documentation/HOWTO/fr/netfilter-extensions-HOWTO.sgml	2003-0=
3-10 01:16:56.000000000 +0100
+++ netfilter-docfix/documentation/HOWTO/fr/netfilter-extensions-HOWTO.sgml=
	2003-06-20 11:29:25.000000000 +0200
@@ -242,7 +242,7 @@
=20
 <tscreen>
 <verb>
-# make all install
+# make; make install
 </verb>
 </tscreen>
=20
diff -urN netfilter/documentation/HOWTO/netfilter-extensions-HOWTO.sgml net=
filter-docfix/documentation/HOWTO/netfilter-extensions-HOWTO.sgml
--- netfilter/documentation/HOWTO/netfilter-extensions-HOWTO.sgml	2003-06-0=
1 12:01:32.000000000 +0200
+++ netfilter-docfix/documentation/HOWTO/netfilter-extensions-HOWTO.sgml	20=
03-06-20 11:27:35.000000000 +0200
@@ -235,7 +235,7 @@
=20
 <tscreen>
 <verb>
-# make all install
+# make; make install
 </verb>
 </tscreen>
=20
diff -urN netfilter/documentation/HOWTO/pl/netfilter-extensions-HOWTO.sgml =
netfilter-docfix/documentation/HOWTO/pl/netfilter-extensions-HOWTO.sgml
--- netfilter/documentation/HOWTO/pl/netfilter-extensions-HOWTO.sgml	2002-0=
2-09 10:47:39.000000000 +0100
+++ netfilter-docfix/documentation/HOWTO/pl/netfilter-extensions-HOWTO.sgml=
	2003-06-20 11:30:21.000000000 +0200
@@ -178,7 +178,7 @@
=20=0D
 <tscreen>=0D
 <verb>=0D
-# make all install=0D
+# make; make install=0D
 </verb>=0D
 </tscreen>=0D
=20=0D

--=-Mz4opHtNIWjgyC6y9Vr8--
