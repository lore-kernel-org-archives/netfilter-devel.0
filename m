From: AFT <aftnix@gmail.com>
Subject: Building xtables-addons
Date: Wed, 04 Jul 2012 19:20:45 +0600
Message-ID: <a9zfirwy.fsf@s1.test.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pb0-f46.google.com ([209.85.160.46]:47118 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab2GDNau (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 4 Jul 2012 09:30:50 -0400
Received: by pbbrp8 with SMTP id rp8so11045475pbb.19
        for <netfilter-devel@vger.kernel.org>; Wed, 04 Jul 2012 06:30:50 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>



Hi,

I have cloned xtables-addons git repo from SF. It has a "autogen.sh" to
create the configure script. ./autogen.sh is failing with following
message:

/usr/bin/m4:configure.ac:33: Warning: excess arguments to builtin `m4_if' ignored
autom4te: /usr/bin/m4 failed with exit status: 1
aclocal: autom4te failed with exit status: 1
autoreconf: aclocal failed with exit status: 1


I'm not experienced in autotools, so i'm clueless about what's actually
going on there.


Cheers,
aft
