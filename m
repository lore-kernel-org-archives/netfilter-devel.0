From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 0/2] Series Add Json Support
Date: Fri, 05 Jul 2013 14:41:20 +0200
Message-ID: <20130705123837.23285.5489.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: eric@regit.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f48.google.com ([74.125.82.48]:63006 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755591Ab3GEMlY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 5 Jul 2013 08:41:24 -0400
Received: by mail-wg0-f48.google.com with SMTP id f11so1950560wgh.27
        for <netfilter-devel@vger.kernel.org>; Fri, 05 Jul 2013 05:41:22 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

I have done the function for exporting set to JSON Format and I have ch=
anged
nft-table-get for exporting tables in other families.

---

=C3=81lvaro Neira Ayuso (2):
      set: add Json Export Support
      examples: nft-table-get different families options


 examples/nft-set-elem-get.c |   15 ++++++++----
 examples/nft-set-get.c      |   15 ++++++++----
 examples/nft-table-get.c    |   26 ++++++++++++++++----
 include/libnftables/set.h   |    5 ++++
 src/set.c                   |   56 +++++++++++++++++++++++++++++++++++=
++++++--
 src/set_elem.c              |   49 +++++++++++++++++++++++++++++++++++=
+--
 6 files changed, 147 insertions(+), 19 deletions(-)

--=20
=C3=81lvaro Neira Ayuso
--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
