From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/8] Allow reuse of plugin instance (and misc fixes)
Date: Sun,  9 Mar 2008 23:36:21 +0100
Message-ID: <12051021893015-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:57588 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752677AbYCIWgb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 9 Mar 2008 18:36:31 -0400
Received: from eric by localhost with local (Exim 4.67)
	(envelope-from <eric@bayen.regit.org>)
	id 1JYU85-0005Zn-Lp
	for netfilter-devel@vger.kernel.org; Sun, 09 Mar 2008 23:36:29 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This patchset starts with some cleaning:
 - Add hook to list of fields in database for packet logging.
 - Introduce RAWSTR type to avoid confusion in future developement.
 - Fix indentation in ulogd_inppkt_NFLOG.c

Latest patches introduce a modification of plugin behaviour. It was not
possible with existing code to reuse a plugin instance. For example, it
is not possible to do :
stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu1:LOGEMU
stack=log1:NFLOG,base1:BASE,ifi1:IFINDEX,ip2str1:IP2STR,print1:PRINTPKT,emu2:LOGEMU

This kind of setup is useful to be able to log in a file and in a database for
example. To be able to have such a setup it is necessary:
 - Not to call twice or more start function to avoid problem (it is not possible
 to listen to the same nfgroup more than once)
 - Duplicate the message in the INPUT module.
This patchset contains ulogd necessary modifications and modifications of NFLOG,
ULOG and NFCT INPUT plugins.

The patches are :
 - Don't call start function multiple time for a single plugin instance.
 - Add a list of used plugininstance.
 - Duplicate message to all existing instance of NFLOG.
 - Add code for duplication of message in ULOG
 - Duplication of message in NFCT input plugin

Global stats:
 doc/mysql-ulogd2.sql              |   17 +++++++++++------
 doc/pgsql-ulogd2.sql              |   20 ++++++++++++--------
 filter/ulogd_filter_IP2BIN.c      |   12 ++++++------
 include/ulogd/ulogd.h             |    3 +++
 input/flow/ulogd_inpflow_NFCT.c   |    7 +++++++
 input/packet/ulogd_inppkt_NFLOG.c |   12 ++++++++++--
 input/packet/ulogd_inppkt_ULOG.c  |    5 +++++
 src/ulogd.c                       |   35 ++++++++++++++++++++++++++++++-----
 util/db.c                         |    5 ++++-
 9 files changed, 88 insertions(+), 28 deletions(-)

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
