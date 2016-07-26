From: Sami Kerola <kerolasa@iki.fi>
Subject: Re: [PATCH] manpages: do not adjust reject-with type footnote
 indentation
Date: Tue, 26 Jul 2016 15:14:22 +0100 (BST)
Message-ID: <alpine.LNX.2.20.1607261513020.7115@imuri>
References: <20160726135906.6808-1-kerolasa@iki.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wm0-f68.google.com ([74.125.82.68]:32960 "EHLO
	mail-wm0-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752213AbcGZOOe (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 26 Jul 2016 10:14:34 -0400
Received: by mail-wm0-f68.google.com with SMTP id o80so1900057wme.0
        for <netfilter-devel@vger.kernel.org>; Tue, 26 Jul 2016 07:14:33 -0700 (PDT)
Received: from imuri (88-108-219-174.dynamic.dsl.as9105.com. [88.108.219.174])
        by smtp.gmail.com with ESMTPSA id o4sm1218721wjd.15.2016.07.26.07.14.32
        for <netfilter-devel@vger.kernel.org>
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 26 Jul 2016 07:14:32 -0700 (PDT)
In-Reply-To: <20160726135906.6808-1-kerolasa@iki.fi>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, 26 Jul 2016, Sami Kerola wrote:

*sigh* let me try again without typo.

--->8----
From: Sami Kerola <kerolasa@iki.fi>
Date: Tue, 26 Jul 2016 14:51:10 +0100
Subject: [PATCH] manpages: do not adjust reject-with type footnote indentation

The footnote clarification to option argument documentation, so keep the
indentation level same as for the arguments.

Signed-off-by: Sami Kerola <kerolasa@iki.fi>
---
 extensions/libipt_REJECT.man | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/extensions/libipt_REJECT.man b/extensions/libipt_REJECT.man
index 926da03..8a360ce 100644
--- a/extensions/libipt_REJECT.man
+++ b/extensions/libipt_REJECT.man
@@ -28,5 +28,5 @@ TCP RST packet to be sent back.  This is mainly useful for blocking
 .I ident
 (113/tcp) probes which frequently occur when sending mail to broken mail
 hosts (which won't accept your mail otherwise).
-.PP
+.IP
 (*) Using icmp\-admin\-prohibited with kernels that do not support it will result in a plain DROP instead of REJECT
-- 
2.9.0

