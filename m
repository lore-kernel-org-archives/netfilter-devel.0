From: martinbarrowcliff <martinbarrowcliff@gmail.com>
Subject: xtables addons; mktemp
Date: Fri, 02 Jul 2010 21:59:00 -0400
Message-ID: <4C2E9964.5030002@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-gx0-f174.google.com ([209.85.161.174]:43080 "EHLO
	mail-gx0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751982Ab0GCB5q (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 2 Jul 2010 21:57:46 -0400
Received: by gxk23 with SMTP id 23so1913896gxk.19
        for <netfilter-devel@vger.kernel.org>; Fri, 02 Jul 2010 18:57:45 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This is a small but annoying issue.
With my embedded firewall system the busybox mktemp function
fails due to unsupported flags, so the xtables-addons build fails
on the native toolchain. This can be fixed.
I hacked the code to make it work properly however I won't send
a patch because it is a amateur hack, and not a proper fix.
I think this issue should be considered, because so many appliances
do use busybox and some may even have a working toolchain...

make[1]: Leaving directory 
`/usr/src/source/build/firewall/xtables-addons-1.27/extensions'
mktemp: invalid option -- u
BusyBox v1.16.2 (2010-06-30 20:04:07 EDT) multi-call binary.

Usage: mktemp [-dt] [-p DIR] [TEMPLATE]

Create a temporary file with name based on TEMPLATE and print its name.
TEMPLATE must end with XXXXXX (e.g. [/dir/]nameXXXXXX).

Options:
        -d      Make a directory instead of a file
        -t      Generate a path rooted in temporary directory
        -p DIR  Use DIR as a temporary directory (implies -t)

For -t or -p, directory is chosen as follows:
$TMPDIR if set, else -p DIR, else /tmp

Thanks much,

Marty B.



