From: Jon Grant <jg@jguk.org>
Subject: kernel source code files with same name (different case) xt_*
Date: Tue, 26 Apr 2011 21:47:07 +0100
Message-ID: <BANLkTinDLPBeYkLE17cyhQg5m-_ZTWbgXg@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gy0-f174.google.com ([209.85.160.174]:56829 "EHLO
	mail-gy0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753389Ab1DZUrI (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Apr 2011 16:47:08 -0400
Received: by gyd10 with SMTP id 10so373024gyd.19
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Apr 2011 13:47:07 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello

When extracting kernel source on a partition which does not support
filenames with different case of the same letters (NTFS), I noticed
/include/linux/netfilter/ files have a CAPS version, and lower case
version. The netfilter/KBuild file refers to the CAPS file in certain
cases, which then simply includes the lower-case filename.

Would a patch be considered for review which amended the
netfilter/KBuild to simply refer to the lower-case files, and deleted
the CAPS version files?

An alternative idea would be to make them alphabetically unique. e.g.
appending_def to the CAPS filenames (i.e. xt_CONNMARK_def.h). Of cause
both of these options depend on if agreement that having
alphabetically unique names is something worth the change.

linux kernel files with different case

Looking at 2.6.38.3

/include/linux/netfilter/


xt_CONNMARK.h
includes "xt_connmark.h"

xt_DSCP.h  (contains struct)
xt_dscp.h

xt_MARK.h
includes "xt_mark.h"

xt_RATEEST.h  (contains struct)
xt_rateest.h

xt_TCPMSS.h  (contains struct)
xt_tcpmss.h


There are two other files in ip4 folder, in addition C files:

ipt_ecn.c
xt_dscp.c
xt_hl.c
xt_rateest.c
xt_tcpmss.c

I know ideally we'd only extract the tar.bz on a regular GNU+Linux
system (ext4 formatted partition). Would a patch to rename these files
to be alphabetically unique be accepted for review?

I will wait for reply before starting to prepare a patch. In addition,
then I would look into the files comprehensively.

Thank you for reading this far. Please keep my email address included
in any replies.
Cheers, Jon
