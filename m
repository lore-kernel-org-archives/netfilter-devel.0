From: Phil Oester <kernel@linuxace.com>
Subject: [PATCH] ulogd specfile typos
Date: Mon, 28 Mar 2005 10:06:20 -0800
Message-ID: <20050328180620.GA1576@linuxace.com>
Mime-Version: 1.0
Content-Type: multipart/mixed; boundary="LQksG6bCIzRHxTLp"
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
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


--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

As pointed out by Kenneth Porter, a few typos/inaccuracies in ulogd .spec.

Closes bugzilla #313

Phil



--LQksG6bCIzRHxTLp
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment; filename=patch-ulogspec

diff -ru ulogd-orig/ulogd.spec ulogd-1.22/ulogd.spec
--- ulogd-orig/ulogd.spec	2005-02-16 02:11:39.000000000 -0800
+++ ulogd-1.22/ulogd.spec	2005-03-28 10:04:31.000000000 -0800
@@ -1,10 +1,10 @@
 Summary: ulogd - The userspace logging daemon for netfilter
 Name: ulogd
-Version: 1.21
+Version: 1.22
 Release: 1gm
 License: GPL
 Group: Network
-Source: http://ftp.netfilter.org/pub/ulogd/%{name}-%{version}.tar.gz
+Source: ftp://ftp.netfilter.org/pub/ulogd/%{name}-%{version}.tar.bz2
 BuildRoot: %{_tmppath}/%{name}-%{version}-root
 Packager: Harald Welte <laforge@gnumonks.org>
 BuildRequires: MySQL-devel postgresql-devel libpcap-devel libsqlite3-devel
@@ -19,11 +19,11 @@
 Group: Network
 
 %package sqlite
-Summarry: SQLITE3 output plugin for ulogd
+Summary: SQLITE3 output plugin for ulogd
 Group: Network
 
 %package pcap
-Summarry: PCAP output plugin for ulogd
+Summary: PCAP output plugin for ulogd
 Group: Network
 
 

--LQksG6bCIzRHxTLp--
