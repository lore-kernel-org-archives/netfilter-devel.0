From: Pierre Chifflier <chifflier@inl.fr>
Subject: [ULOG PATCH 0/4] misc fixes, and new DBI output plugin
Date: Mon,  1 Dec 2008 13:41:52 +0100
Message-ID: <1228135316-12578-1-git-send-email-chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:55867 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1751186AbYLANYq (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 1 Dec 2008 08:24:46 -0500
Received: from piche.inl.fr ([192.168.33.181])
	by fydelkass.inl.fr with esmtp (Exim 4.63)
	(envelope-from <chifflier@inl.fr>)
	id 1L7869-0003JA-0C
	for netfilter-devel@vger.kernel.org; Mon, 01 Dec 2008 13:41:57 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

The first two patches fixes the following problems:
- impossibility to run ulogd in gdb, due to a missing link to libpthread
- possible use of uninitialized memory in a calloc(0), spotted by valgrind

It also adds a new output mode, libdbi
libdbi implements a database-independent abstraction layer in C, similar to
the DBI/DBD layer in Perl.
It allows to use all database types supported by libdbi, including
MySQL, PostgreSQL, sqlite, Firebird, MSSQL, Sybase, Oracle, ingres ..

It does not, however, replace other database modules, because as a common
abstraction layer, it is unable to use any specific function, for ex. the
asynchronous API for PostgreSQL.

