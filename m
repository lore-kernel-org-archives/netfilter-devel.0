From: Eric Leblond <eric@regit.org>
Subject: [ulogd patch 0/5] nfacct and pgsql update
Date: Wed,  1 Aug 2012 23:27:11 +0200
Message-ID: <1343856436-11129-1-git-send-email-eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:49514 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755421Ab2HAV2Y (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 1 Aug 2012 17:28:24 -0400
Received: from ip-92-50-100-48.unitymediagroup.de ([92.50.100.48] helo=tiger.regit.org)
	by ks28632.kimsufi.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <eric@regit.org>)
	id 1SwgSr-0005bd-B5
	for netfilter-devel@vger.kernel.org; Wed, 01 Aug 2012 23:28:21 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


This patchset adds some new features to nfacct:

 * nfacct: add variable to not zero counter after read
 * pgsql schema: add nfacct table
 * pgsql: only disable key if it starts with underscore
 * nfacct: add timestamp option

and fixes an issue found by Mr Dash Four.

 * pgsql schema: fix timestamp default value

Patchset statistics:
 doc/pgsql-ulogd2.sql              |   24 +++++++++++++++++++++++-
 input/sum/ulogd_inpflow_NFACCT.c  |   62 ++++++++++++++++++++++++++++++++++++++++++++++++++++++--------
 output/pgsql/ulogd_output_PGSQL.c |    6 ++++--
 ulogd.conf.in                     |   12 ++++++++++++
 4 files changed, 93 insertions(+), 11 deletions(-)

BR,
--
Eric
