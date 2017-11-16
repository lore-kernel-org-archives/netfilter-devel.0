From: Jason Hendry <jhendry@mintel.com>
Subject: conntracd init.d reload is broken on Centos6
Date: Thu, 16 Nov 2017 10:47:15 +0000
Message-ID: <CAPyb0YcPtkruBLSVfxBnU1jrkL_5PgCxLvN56pMgexPHx=RZrQ@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vk0-f44.google.com ([209.85.213.44]:46556 "EHLO
        mail-vk0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S933077AbdKPKrr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 16 Nov 2017 05:47:47 -0500
Received: by mail-vk0-f44.google.com with SMTP id k123so16224783vkb.3
        for <netfilter-devel@vger.kernel.org>; Thu, 16 Nov 2017 02:47:46 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

Was not sure where to send this so hoping this is the right place.  We
am running Centos6 with conntrack-tools.  The reload option to the
conntrackd init.d script does not work due to a syntax error on the
killproc init function.

Bug:

[root@test-brfw01 ~]# /etc/init.d/conntrackd reload
Reloading conntrackd configuration: pidof: invalid options on command line!

pidof: invalid options on command line!

                                                           [FAILED]


Environment:

[root@test-brfw01 ~]# uname -a
Linux test-brfw01.london.mintel.ad 2.6.32-696.10.1.el6.x86_64 #1 SMP
Tue Aug 22 18:51:35 UTC 2017 x86_64 x86_64 x86_64 GNU/Linux

[root@test-brfw01 ~]# yum info conntrack-tools.x86_64
Loaded plugins: changelog, fastestmirror, priorities, rhnplugin,
security, versionlock
This system is receiving updates from RHN Classic or Red Hat Satellite.
Loading mirror speeds from cached hostfile
106 packages excluded due to repository priority protections
Installed Packages
Name        : conntrack-tools
Arch        : x86_64
Version     : 0.9.13
Release     : 3.el6
Size        : 403 k
Repo        : installed
>From repo   : el6_epel
Summary     : Tools to manipulate netfilter connection tracking table
URL         : http://netfilter.org
License     : GPLv2


Patch/Fix:

Index: conntrackd
===================================================================
--- conntrackd   (revision 46829)
+++ conntrackd   (working copy)
@@ -85,7 +85,7 @@
 # XXX: can conntrackd reload?
 reload() {
         echo -n $"Reloading $prog configuration: "
-        killproc -HUP $prog
+        killproc $prog -HUP
         retval=$?
         echo
         return $retval


If you prefer this be submitted somewhere else or in a different
format I am happy to do so.

Jason H
Senior Systems Administrator
+44 (0)203 416 4316

-- 

Mintel Group Ltd | 11 Pilgrim Street | London | EC4V 6RN
Registered in England: Number 1475918. | VAT Number: GB 232 9342 72

Contact details for our other offices can be found at 
http://www.mintel.com/office-locations.

This email and any attachments may include content that is confidential, 
privileged 
or otherwise protected under applicable law. Unauthorised disclosure, 
copying, distribution 
or use of the contents is prohibited and may be unlawful. If you have 
received this email in error,
including without appropriate authorisation, then please reply to the 
sender about the error 
and delete this email and any attachments.

