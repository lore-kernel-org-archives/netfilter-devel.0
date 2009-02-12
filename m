From: Ignacy Gawedzki <i@lri.fr>
Subject: Re: Netfilter API and libiptc
Date: Thu, 12 Feb 2009 14:33:07 +0100
Message-ID: <20090212133307.GA4475@zenon.in.qult.net>
References: <20090205141722.GB21417@qubit> <4990636B.9080900@trash.net> <20090209183941.GA1050@zenon.in.qult.net> <Pine.LNX.4.64.0902111408210.4822@ask.diku.dk> <4992E2B3.3030009@trash.net> <alpine.LSU.2.00.0902111656400.22845@fbirervta.pbzchgretzou.qr> <4993AFF9.9010002@trash.net> <alpine.LSU.2.00.0902120640480.32504@fbirervta.pbzchgretzou.qr> <Pine.LNX.4.64.0902121014550.22322@ask.diku.dk> <Pine.LNX.4.64.0902121125190.22398@ask.diku.dk>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="VS++wcV0S1rZb1Fb"
Cc: Jan Engelhardt <jengelh@medozas.de>,
	Patrick McHardy <kaber@trash.net>,
	Netfilter Developers <netfilter-devel@vger.kernel.org>,
	hawk@comx.dk
To: Jesper Dangaard Brouer <hawk@diku.dk>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from qult.net ([82.238.217.46]:45699 "EHLO slartibartfast.qult.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757488AbZBLNdS (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 12 Feb 2009 08:33:18 -0500
Content-Disposition: inline
In-Reply-To: <Pine.LNX.4.64.0902121125190.22398@ask.diku.dk>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


--VS++wcV0S1rZb1Fb
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

On Thu, Feb 12, 2009 at 11:42:08AM +0100, thus spake Jesper Dangaard Brouer:
> Whats missing is that the libiptc.h header file should be installed.
> My patch below is not doing the right thing. I don't know automake well  
> enough, to make it create a directory libiptc/ under include/ where it  
> should install libiptc.h.

See the attached patch.  The idea is to add a Makefile.am into include/ and
then use the nobase_ prefix to prevent automake from stripping the
subdirectory name from the files.

-- 
Sex on TV doesn't hurt....unless you fall off.

--VS++wcV0S1rZb1Fb
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment; filename="iptables-headers.patch"

diff --git a/Makefile.am b/Makefile.am
index dbdfa97..3ea4a69 100644
--- a/Makefile.am
+++ b/Makefile.am
@@ -79,7 +79,8 @@ man_MANS         = iptables.8 iptables-restore.8 iptables-save.8 \
                    ip6tables-save.8
 CLEANFILES       = iptables.8 ip6tables.8
 if ENABLE_DEVEL
-include_HEADERS  = include/xtables.h
+SUBDIRS += include
+#nobase_include_HEADERS  = include/xtables.h include/libiptc/libiptc.h
 endif
 
 if ENABLE_STATIC
diff --git a/configure.ac b/configure.ac
index 888ba42..96a2c8d 100644
--- a/configure.ac
+++ b/configure.ac
@@ -78,6 +78,6 @@ AC_SUBST([libxtables_vage])
 libxtables_vmajor=$(($libxtables_vcurrent - $libxtables_vage));
 AC_SUBST([libxtables_vmajor])
 
-AC_CONFIG_FILES([Makefile extensions/GNUmakefile libipq/Makefile
+AC_CONFIG_FILES([Makefile extensions/GNUmakefile include/Makefile libipq/Makefile
 	include/xtables.h include/iptables/internal.h xtables.pc])
 AC_OUTPUT
diff --git a/include/Makefile.am b/include/Makefile.am
new file mode 100644
index 0000000..7564466
--- /dev/null
+++ b/include/Makefile.am
@@ -0,0 +1 @@
+nobase_include_HEADERS = xtables.h libiptc/libiptc.h

--VS++wcV0S1rZb1Fb--
