From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 0/2] [arptables] Fixes for problems found by static analysis.
Date: Wed,  2 Oct 2013 10:43:36 +0200
Message-ID: <1380703418-3067-1-git-send-email-jpopelka@redhat.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: QUOTED-PRINTABLE
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:65366 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753296Ab3JBInr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 2 Oct 2013 04:43:47 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id r928hk2P009577
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Wed, 2 Oct 2013 04:43:47 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We analyzed the arptables-0.4.4 code with Coverity - tool for static an=
alysis.
Each patch contains relevant part of the Coverity scan output.

Jarom=C3=ADr Kon=C4=8Dick=C3=BD (2):
  Error: STRING_NULL
  Error: STRING_OVERFLOW

 userspace/arptables/arptables.c              | 13 ++++++++-----
 userspace/arptables/libarptc/libarptc_incl.c | 16 ++++++++++------
 2 files changed, 18 insertions(+), 11 deletions(-)

--=20
1.8.3.1

--
To unsubscribe from this list: send the line "unsubscribe netfilter-dev=
el" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
