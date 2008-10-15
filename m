From: Pierre Chifflier <chifflier@inl.fr>
Subject: [ULOGD2] basic patches
Date: Wed, 15 Oct 2008 11:50:11 +0200
Message-ID: <1224064214-9074-1-git-send-email-chifflier@inl.fr>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from 141-53.206-83.static-ip.oleane.fr ([83.206.53.141]:46709 "EHLO
	fydelkass.inl.fr" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751438AbYJOKGl (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 06:06:41 -0400
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>


Hi,

These patchset fix the following problems:

- We don't need to add constraints in the PostgreSQL table, the application
  already checks for port value. Constraints only slow down insertions.

- Finish the renaming of MAC2STR plugin to HWHDR

- Fix a potential segfault in HWHDR plugin, when mac is NULL (e.g when using
  ulogd2 on OUTPUT).

Cheers,
Pierre
