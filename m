From: Eric Leblond <eric@inl.fr>
Subject: [ULOGD PATCH 0/4] NFCT input and output update
Date: Thu, 15 May 2008 00:54:35 +0200
Message-ID: <1210805679-11813-1-git-send-email-eric@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from bayen.regit.org ([81.57.69.189]:33851 "EHLO ice-age"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752307AbYENWy2 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 14 May 2008 18:54:28 -0400
Received: from eric by ice-age with local (Exim 4.69)
	(envelope-from <eric@bayen.regit.org>)
	id 1JwPrr-000357-My
	for netfilter-devel@vger.kernel.org; Thu, 15 May 2008 00:54:39 +0200
In-Reply-To: <>
References: <>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hello,

This patchset update NFCT and PGSQL to sync with latest kernel (or latest
ulogd modules).

The two following patches modify the PGSQL schema to be in sync with latest
NFCT keys and add a new function to be able to maintain the connection
history without having the conntrack ID:
 * Sync-PGSQL-schema-with-NFCT
 * Add-INSERT_OR_REPLACE_CT-pgsql-function

This two patches fix the NFCT input plugin by computing the start or end
timestamp without using a hash. It also fixes a bug due to the usage of a
deprecated enum:
 * Partially-fill-connection-timestamp-when-hash-is-not
 * Suppress-usage-of-deprecated-enum

BR,
--
Eric Leblond
INL: http://www.inl.fr/
NuFW: http://www.nufw.org/
