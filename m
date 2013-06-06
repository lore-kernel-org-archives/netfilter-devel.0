From: Alvaro Neira <alvaroneay@gmail.com>
Subject: [libnftables PATCH 0/4] Series short description
Date: Thu, 06 Jun 2013 15:15:28 +0200
Message-ID: <20130606131506.17910.25285.stgit@Ph0enix>
Mime-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Cc: ulien@linuxwall.info
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-wg0-f41.google.com ([74.125.82.41]:33156 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752587Ab3FFNPk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 6 Jun 2013 09:15:40 -0400
Received: by mail-wg0-f41.google.com with SMTP id k13so327923wgh.2
        for <netfilter-devel@vger.kernel.org>; Thu, 06 Jun 2013 06:15:39 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Json support for to export tables to JSON format and I add the example for to use the new functions

---

Alvaro Neira (4):
      Add functions for to export tables to JSON format
      Add implementation for to proof the JSON export function
      Add JSON Constant for to use the Json export function
      Add a constant for to put the JSON Version


 examples/nft-table-get.c |    4 ++++
 1 file changed, 4 insertions(+)

-- 
Signature
