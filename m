From: Anton <anton.vazir@gmail.com>
Subject: Re: SVN ULOG2
Date: Sat, 12 Apr 2008 13:07:33 +0500
Message-ID: <200804121307.33557.anton.vazir@gmail.com>
References: <200804091520.28617.anton.vazir@gmail.com> <200804101803.40843.anton.vazir@gmail.com> <53696.62.160.220.138.1207832972.squirrel@mail.inl.fr>
Mime-Version: 1.0
Content-Type: Multipart/Mixed;
  boundary="Boundary-00=_F3GAIQeQRQeHWrB"
Cc: "Netfilter Developer Mailing List" <netfilter-devel@vger.kernel.org>
To: "Eric Leblond" <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.eastera.tj ([82.198.21.18]:43737 "EHLO mail.eastera.tj"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754124AbYDLIHf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Apr 2008 04:07:35 -0400
In-Reply-To: <53696.62.160.220.138.1207832972.squirrel@mail.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

--Boundary-00=_F3GAIQeQRQeHWrB
Content-Type: text/plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline

Patch is attached

On Thursday 10 April 2008 18:09, Eric Leblond wrote:
> > Maybe it's worth to add this line into a sample
> > ulogd.conf to avoid stupid questions from newbees like
> > me :)
>
> Just send to the ML a patch to ulogd.conf.in with these
> modifications ;)

--Boundary-00=_F3GAIQeQRQeHWrB
Content-Type: text/x-diff;
  charset="iso-8859-1";
  name="conf.ini.diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
	filename="conf.ini.diff"

diff -Naur ulogd2/ulogd.conf.in ulogd2-doc/ulogd.conf.in
--- ulogd2/ulogd.conf.in	2008-04-12 13:02:50.000000000 +0500
+++ ulogd2-doc/ulogd.conf.in	2008-04-12 13:04:40.000000000 +0500
@@ -39,6 +39,7 @@
 plugin="@libdir@/ulogd/ulogd_filter_IP2STR.so"
 plugin="@libdir@/ulogd/ulogd_filter_IP2BIN.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTPKT.so"
+plugin="@libdir@/ulogd/ulogd_filter_MAC2STR.so"
 plugin="@libdir@/ulogd/ulogd_filter_PRINTFLOW.so"
 plugin="@libdir@/ulogd/ulogd_output_LOGEMU.so"
 plugin="@libdir@/ulogd/ulogd_output_SYSLOG.so"
@@ -74,7 +75,7 @@
 #stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2bin1:IP2BIN,mysql1:MYSQL
 
 # this is a stack for logging IPv6 packet to PGsql after a collect via NFLOG
-#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,pgsql1:PGSQL
+#stack=log2:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,mac2str1:MAC2STR,pgsql1:PGSQL
 
 # this is a stack for logging ebtables packets to syslog after a collect via NFLOG
 #stack=log3:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,sys1:SYSLOG

--Boundary-00=_F3GAIQeQRQeHWrB--
