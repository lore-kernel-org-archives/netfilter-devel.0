From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [RFC] masquerading/conntrack
Date: Thu, 22 May 2008 15:00:11 +0200
Message-ID: <48356E5B.6030402@netfilter.org>
References: <dd45289d0805210133o49d44292qf238b15fec66a0d2@mail.gmail.com>	 <4833F119.7080206@netfilter.org>	 <dd45289d0805210623s29f69e45t6fb8ac5b01622d82@mail.gmail.com>	 <48342C03.10204@netfilter.org>	 <dd45289d0805210725r4409b860if06bc8adb68059be@mail.gmail.com>	 <48343B76.4090404@netfilter.org> <dd45289d0805210913j766083e2m3ae50d846320f09c@mail.gmail.com>
Mime-Version: 1.0
Content-Type: multipart/mixed;
 boundary="------------010508090101050302080504"
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56798 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1760076AbYEVNAV (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 22 May 2008 09:00:21 -0400
In-Reply-To: <dd45289d0805210913j766083e2m3ae50d846320f09c@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a multi-part message in MIME format.
--------------010508090101050302080504
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

NICOLAS BOULIANE wrote:
>> This report is really strange, your flex implementation is generating
>> useless code. What version are you using? Here I'm using flex 2.5.33.
>>
> 
> [nib@bwm ~]$ flex --version
> flex version 2.5.4
> [nib@bwm ~]$
> 
> [nib@bwm ~]$ yum info flex
> Loading "installonlyn" plugin
> Setting up repositories
> Reading repository metadata in from local files
> Installed Packages
> Name   : flex
> Arch   : i386
> Version: 2.5.4a
> Release: 41.fc6
> Size   : 239 k
> Repo   : installed
> ...
> 
> Centos is running on this machine.

Centos seems to be using a caveman flex version! From 1997, 11 years ago!

I have committed the following patch to warn people about using old flex
version.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers

--------------010508090101050302080504
Content-Type: text/plain;
 name="x"
Content-Transfer-Encoding: 7bit
Content-Disposition: inline;
 filename="x"

diff --git a/configure.in b/configure.in
index f3b8785..0a6b8fe 100644
--- a/configure.in
+++ b/configure.in
@@ -49,6 +49,21 @@ then
 	exit 1
 fi
 
+AC_MSG_CHECKING(flex version)
+flex_version=`$LEX --version | sed 's/version//g' | awk '/flex/ {print $2}'`
+flex_major=`echo $flex_version| cut -d . -f 1`
+flex_minor=`echo $flex_version| cut -d . -f 2`
+flex_rev=`echo $flex_version| cut -d . -f 3`
+ 
+if test "$flex_major" -eq "2" && test "$flex_minor" -eq "5" && test "$flex_rev" -ge "33"; then
+	AC_MSG_RESULT([$flex_version. OK])
+else
+	AC_MSG_WARN([flex version $flex_version found.
+	Version 2.5.33 or greater is required. You may experience problems
+	while compilating the conntrack-tools. Please, consider to upgrade 
+	flex.])
+fi
+
 AC_CHECK_HEADERS([linux/capability.h],, [AC_MSG_ERROR([Cannot find linux/capabibility.h])])
 
 # Checks for libraries.

--------------010508090101050302080504--
