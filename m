From: Eric Leblond <eric@regit.org>
Subject: [RFC PATCH 0/1] add insert after to nf_tables
Date: Wed, 19 Jun 2013 10:03:16 +0200
Message-ID: <1371628997-13548-1-git-send-email-eric@regit.org>
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from ks28632.kimsufi.com ([91.121.96.152]:46684 "EHLO
	ks28632.kimsufi.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933328Ab3FSIDk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 19 Jun 2013 04:03:40 -0400
Received: from bayen.regit.org ([81.57.69.189] helo=ice-age.regit.org)
	by ks28632.kimsufi.com with esmtpsa (TLS1.0:DHE_RSA_AES_256_CBC_SHA1:32)
	(Exim 4.72)
	(envelope-from <eric@regit.org>)
	id 1UpDMg-0000Ev-1I
	for netfilter-devel@vger.kernel.org; Wed, 19 Jun 2013 10:03:38 +0200
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hello,

The patch
	netfilter: nf_tables: add insert operation
adds support for inserting a rule after a handle.

It is followed by the patch
	examples: add insert rule example
which is the libnftables example.

I choose to reuse the CREATE operation in the kernel code
to avoid to add a new message to netlink. This way we have
a sort of 'create after' syntax. This is almost natural IMHO.

BR,
--
Eric
