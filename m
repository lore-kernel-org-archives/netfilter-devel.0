From: Pierre Chifflier <chifflier@inl.fr>
Subject: Database update: add label, update views and conntrack
Date: Mon, 21 Apr 2008 23:58:22 +0200
Message-ID: <1208815106-3315-1-git-send-email-chifflier@inl.fr>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from neuf-infra-smtp-out-sp604007av.neufgp.fr ([84.96.92.120]:32954
	"EHLO neuf-infra-smtp-out-sp604007av.neufgp.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752973AbYDUVy5 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 21 Apr 2008 17:54:57 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

This patchset adds support for the 'label' option, converts INSERT_CT
to a function for consistency, and adds a function to the MySQL schema
to display binary addresses as strings.
It also adds the INSERT_CT function to the PostgreSQL schema.


