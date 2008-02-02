From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD RFC PATCH 0/34]
Date: Sat,  2 Feb 2008 22:23:55 +0100
Message-ID: <1201987469575-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:46004 "EHLO localhost"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1761776AbYBBWOm (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 2 Feb 2008 17:14:42 -0500
Received: from eric by localhost with local (Exim 4.67)
	(envelope-from <eric@bayen.regit.org>)
	id 1JLPqf-00066k-QN
	for netfilter-devel@vger.kernel.org; Sat, 02 Feb 2008 22:24:29 +0100
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This patchset contains patches for ulogd2 from Pierre Chifflier and I.

As discussed during Netfilter workshop, the goal of this patchset is to provide
a new and modern SQL logging schema. Some colateral patchs are present in the 
patchset due to the state of Ulogd2. As stated by Holger, people using ulogd2
now are early adopters and we tried to improve usability of ulogd2. For example,
we've added a --info switch to ulogd2 to be able to display option of a plugin.

But, the main work is on SQL logging. Ulogd 1.x schema was really bad. It lacks
index and the way data are stored (one big line per entry full of NULL fields)
is not efficient for databases.

Thus, we propose new schemas for MySQL and PGsql which use advanced database
feature without complication on developper side. In fact, the SQL related C 
code did not change very much. The main change is the use of a call to a SQL
function instead of using a SQL query. The advantage of doing this is to hide
the complexity of the database to developpers and let people knowing databases
work on their side without bothering us.

I will finished this mail by a description of the avantages of the new schema.
It uses a set of small dedicated tables (a TCP tables for example). From an SQL
point of view this is more efficient as we limit the number of NULL fields
(storage of empty datas has a cost). The schema has some SQL views (virtual table)
and some of them provides an near complete backward compatility with the existing
one.

One other advantage of the new schema is that extension (like nufw one) can
used without changing anything for non-aware system.

This patchset should not conflict with Holger patchset (if NFCT related work is
omitted). I can do the merge work if some is needed, just let me know.

BR,
--
Eric Leblond <eric@inl.fr>
INL: http://www.inl.fr/
