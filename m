From: Pierre Chifflier <chifflier@inl.fr>
Subject: (unknown)
Date: Thu, 17 Sep 2009 21:28:18 +0200
Message-ID: <1253215700-15032-1-git-send-email-chifflier@inl.fr>
Cc: eleblond@inl.fr
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from smtp1-g21.free.fr ([212.27.42.1]:49033 "EHLO smtp1-g21.free.fr"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753182AbZIQT21 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 17 Sep 2009 15:28:27 -0400
Received: from smtp1-g21.free.fr (localhost [127.0.0.1])
	by smtp1-g21.free.fr (Postfix) with ESMTP id D35BC940148
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2009 21:28:26 +0200 (CEST)
Received: from fydelkass.edenwall.com (fydelkass.inl.fr [88.171.131.12])
	by smtp1-g21.free.fr (Postfix) with ESMTP id F3ED49400C2
	for <netfilter-devel@vger.kernel.org>; Thu, 17 Sep 2009 21:28:23 +0200 (CEST)
Subject: 
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

These patches fix two problems in ulogd:
- the debian directory in ulogd sources is outdated, and useless (it has
  errors and is not maintained). It's easy to maintain it outside the
  sources anyway
- some views in the flat SQL schema are wrong, they use ip_protocol
  instead of oob_family

Cheers,
Pierre

