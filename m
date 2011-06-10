From: Jiri Popelka <jpopelka@redhat.com>
Subject: [PATCH 0/8] Possible problems found by static analysis of code
Date: Fri, 10 Jun 2011 15:25:54 +0200
Message-ID: <1307712362-17727-1-git-send-email-jpopelka@redhat.com>
Cc: Jiri Popelka <jpopelka@redhat.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mx1.redhat.com ([209.132.183.28]:28453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755721Ab1FJN0i (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 10 Jun 2011 09:26:38 -0400
Received: from int-mx01.intmail.prod.int.phx2.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
	by mx1.redhat.com (8.14.4/8.14.4) with ESMTP id p5ADQcRt018670
	(version=TLSv1/SSLv3 cipher=DHE-RSA-AES256-SHA bits=256 verify=OK)
	for <netfilter-devel@vger.kernel.org>; Fri, 10 Jun 2011 09:26:38 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

We had analyzed the iptables-1.4.10 code with Coverity.
Coverity is commercial enterprise level tool for
static analysis (analysis based only on compiling of sources,
not based on running of binary) of the code.

As a result I have the following patches that should fix some possible problems.
There's a respective part(s) of the Coverity error log in each commit comment.

You could also find this link useful:
https://www.securecoding.cert.org/confluence/display/seccode/Coverity+Prevent

Jiri Popelka (8):
  iptables: Coverity: DEADCODE
  iptables: Coverity: FORWARD_NULL
  iptables: Coverity: NEGATIVE_RETURNS
  iptables: Coverity: REVERSE_INULL
  iptables: Coverity: UNINIT
  iptables: Coverity: VARARGS
  iptables: Coverity: OVERRUN_STATIC
  iptables: Coverity: RESOURCE_LEAK

 extensions/libip6t_REJECT.c  |   13 +++++++------
 extensions/libipt_REJECT.c   |   11 ++++++-----
 extensions/libxt_multiport.c |    2 --
 extensions/libxt_sctp.c      |    2 +-
 iptables/ip6tables-restore.c |    3 +--
 iptables/ip6tables.c         |    5 ++++-
 iptables/iptables-restore.c  |    5 ++---
 iptables/iptables-xml.c      |    6 +++---
 iptables/iptables.c          |    8 ++++++--
 iptables/xtables.c           |   15 +++++++++++----
 libipq/libipq.c              |    1 -
 libiptc/libiptc.c            |    8 +++-----
 12 files changed, 44 insertions(+), 35 deletions(-)

-- 
1.7.5.2

