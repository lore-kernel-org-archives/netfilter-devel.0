From: Eric Leblond <eric@regit.org>
Subject: [nft PATCH v2] libnftables preparation work
Date: Mon,  4 Sep 2017 09:55:56 +0200
Message-ID: <20170904075558.10129-1-eric@regit.org>
References: <20170903223441.GB12383@salvia>
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from home.regit.org ([37.187.126.138]:45412 "EHLO home.regit.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1751949AbdIDH4N (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 4 Sep 2017 03:56:13 -0400
In-Reply-To: <20170903223441.GB12383@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi,

This patchset update previous one following Pablo's suggestion:
* remove unused custom netlink flag
* rename ouput function to nft_print
* change default output buffer size to 4k instead of 128 that was used
  for debug (and causing a lot of realloc)

BR,
--
Eric
