From: Holger Eitzenberger <holger@eitzenberger.org>
Subject: [PATCH 0/5] ipset: some small userland improvements
Date: Mon, 08 Sep 2014 16:30:28 +0200
Message-ID: <20140908142604.16930.94892.stgit@jonathan.eitzenberger.org>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: kadlec@blackhole.kfki.hu
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mout.kundenserver.de ([212.227.126.130]:53967 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755AbaIHObb (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 8 Sep 2014 10:31:31 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Jozsef,

what follows are some smaller patches I collected while starting to
implement sorted ipset list ("ipset -s list") output.

They are not directly related to the sorted output, but are IMO still
usefull to have.

I'd like to get them out before sending the initial RFC patches for
the sorted output.

Please check.

Cheers,

 /Holger

---

Holger Eitzenberger (5):
      Remove a duplicate debug print
      ipset: avoid duplicate command flags
      ipset: coalesce two ifs
      ipset: remove extran newline on debug output
      ipset: data callback does not need to be part of cb_ctl[]


 lib/mnl.c     |    6 ++----
 lib/session.c |   12 ++++--------
 2 files changed, 6 insertions(+), 12 deletions(-)

-- 
A dirty mind is a terrible thing to waste.
