From: Natanael Copa <natanael.copa@gmail.com>
Subject: xtables-addons: build fix for --without-kbuild
Date: Tue,  3 Nov 2009 13:54:56 +0000
Message-ID: <1257256497-26243-1-git-send-email-natanael.copa@gmail.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-bw0-f227.google.com ([209.85.218.227]:46054 "EHLO
	mail-bw0-f227.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751200AbZKCNyj (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 3 Nov 2009 08:54:39 -0500
Received: by bwz27 with SMTP id 27so7619178bwz.21
        for <netfilter-devel@vger.kernel.org>; Tue, 03 Nov 2009 05:54:44 -0800 (PST)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

The --without-build is useful when your distro has multiple kernels
but you want a common package for userspace stuff. Patch fixes the
configure script.

Thanks!

-nc

