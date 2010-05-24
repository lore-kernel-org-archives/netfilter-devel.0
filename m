From: Jan Engelhardt <jengelh@medozas.de>
Subject: [patch] Fwd: Troubles compiling iptables v1.4.8
Date: Mon, 24 May 2010 07:53:31 +0200
Message-ID: <1274680413-25691-1-git-send-email-jengelh@medozas.de>
References: <4BF74E78.1030805@lists.schang.net>
Cc: netfilter-devel@vger.kernel.org, netfilter@vger.kernel.org,
	netfilter@lists.schang.net
To: kaber@trash.net
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <4BF74E78.1030805@lists.schang.net>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


Posted in the depths of netfilter@vger, Brian Schang wrote on
2010-05-22 3:24:40:

>make[2]: Entering directory `/raida/packages/iptables/utils'
>gcc -DHAVE_CONFIG_H -I. -I..     -g -O2 -MT nfnl_osf.o -MD -MP -MF 
>.deps/nfnl_osf.Tpo -c -o nfnl_osf.o nfnl_osf.c
>nfnl_osf.c:48:36: error: linux/netfilter/xt_osf.h: No such file or directory
>
>I'm not sure where to turn next. Any insight would be appreciated.


The following changes since commit 8532c70fd182057b440b41f013d8021a95bd72b2:

  Revert "Revert "Merge branch 'iptables-next'"" (2010-05-21 12:57:23 +0200)

are available in the git repository at:
  git://dev.medozas.de/iptables master

Jan Engelhardt (1):
      utils: add missing include flags to Makefile

 utils/Makefile.am |    2 ++
 1 files changed, 2 insertions(+), 0 deletions(-)
