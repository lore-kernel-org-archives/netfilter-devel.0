From: Alexey Perevalov <a.perevalov@samsung.com>
Subject: [PATCH 0/4] Generalize DEBUGP macros
Date: Thu, 25 Jul 2013 13:23:45 +0400
Message-ID: <1374744229-5427-1-git-send-email-a.perevalov@samsung.com>
Cc: pablo@netfilter.org, netfilter@vger.kernel.org,
	Alexey Perevalov <a.perevalov@samsung.com>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-owner@vger.kernel.org>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

It's better to have one common header for keeping debug macro.
There are many files currently define they own trace macros (DEBUGP).
All of them are moved to DEBUGP from trace.h.

Alexey Perevalov (4):
  iptables: Introduce header for keeping debug and trace entities
  extensions: Use DEBUGP macro from trace.h
  iptables: Use DEBUGP macro from trace.h
  libiptc: Use DEBUGP macro from trace.h

 extensions/libxt_dccp.c      |    8 +---
 extensions/libxt_sctp.c      |    8 +---
 extensions/libxt_set.c       |    1 +
 include/trace.h              |   14 +++++++
 iptables/ip6tables-restore.c |    7 +---
 iptables/iptables-restore.c  |    7 +---
 iptables/iptables-xml.c      |    7 +---
 libiptc/libiptc.c            |   90 +++++++++++++++++-------------------------
 8 files changed, 57 insertions(+), 85 deletions(-)
 create mode 100644 include/trace.h

-- 
1.7.9.5

