From: Michael Zintakis <michael.zintakis@googlemail.com>
Subject: [PATCH nfnetlink_acct v2 0/2] numerous changes and improvements
Date: Sun, 14 Apr 2013 10:53:08 +0100
Message-ID: <516A7C84.9000307@googlemail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: pablo@netfilter.org
To: netfilter-devel@vger.kernel.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-lb0-f175.google.com ([209.85.217.175]:40495 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750840Ab3DNJx2 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 14 Apr 2013 05:53:28 -0400
Received: by mail-lb0-f175.google.com with SMTP id o10so3732648lbi.20
        for <netfilter-devel@vger.kernel.org>; Sun, 14 Apr 2013 02:53:26 -0700 (PDT)
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

* check that in nfnetlink_acct.c::nfnl_acct_new both packet and byte
  values are specified and return EINVAL if that is not the case

* fmt and bthr (format and bytes threshold) properties have been added to
  the nfacct object.

* ability to change all nfacct object properties (with the exception of
  name) has been added.

Michael Zintakis (2):
  nfnl_acct_new: packet/byte values check
  add fmt & bthr properties to nfacct

 include/uapi/linux/netfilter/nfnetlink_acct.h |    2 +
 net/netfilter/nfnetlink_acct.c                |   53 +++++++++++++++++++++++--
 2 files changed, 51 insertions(+), 4 deletions(-)

