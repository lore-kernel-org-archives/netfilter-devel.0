From: Pierre Chifflier <chifflier@inl.fr>
Subject: [ULOGD2 0/6] DB performance
Date: Tue,  6 Jan 2009 23:31:12 +0100
Message-ID: <1231281078-31060-1-git-send-email-chifflier@inl.fr>
Cc: netfilter-devel <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 78-210-144-213.altitudetelecom.fr ([213.144.210.78]:52858 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-FAIL-OK-OK) by vger.kernel.org
	with ESMTP id S1755180AbZAFW34 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 6 Jan 2009 17:29:56 -0500
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset aims to improve the DB performance with the following
improvements:

* Allow local (unix socket) connections to PostgreSQL database
This one was spotted while profiling using callgrind, and noticing
unexpected calls to SSL functions. Using a local connection improves
speed a lot (by a factor 4 here).

* Allow plain INSERT instead of stored procedure
If the procedure name specified in config is INSERT, then use regular
insertions to the table.
This should fix sqlite support (which does not support stored
procedures), and is much faster than using procedures + split tables SQL
schema.

* As discussed during the previous workshop, we will offer choice
between the nice but slow tables design, and a flat but fast SQL
schema. This patch adds the flat SQL schemas for MySQL and PostgreSQL.

* Comparison between column and key names should be case insensitive in
the DBI module, since some of the supported databases (like Oracle)
return column names in uppercase.

* A few cleanups on useless constraints. Port numbers validity check is
done by the application, so adding these constraints will only slow down
insertions and bring nothing.

I am currently trying to profile ulogd2, and will have some graphs soon
I hope.

Cheers,
Pierre

