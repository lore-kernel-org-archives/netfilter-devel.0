Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 333A0C433F5
	for <netfilter-devel@archiver.kernel.org>; Thu,  5 May 2022 11:50:33 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231582AbiEELyG (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 5 May 2022 07:54:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356011AbiEELyE (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 5 May 2022 07:54:04 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7E1C6572;
        Thu,  5 May 2022 04:50:23 -0700 (PDT)
Received: from n0-1 by orbyte.nwl.cc with local (Exim 4.94.2)
        (envelope-from <n0-1@orbyte.nwl.cc>)
        id 1nmZzx-00077b-Ns; Thu, 05 May 2022 13:50:21 +0200
Date:   Thu, 5 May 2022 13:50:21 +0200
From:   Phil Sutter <phil@netfilter.org>
To:     netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>
Cc:     netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
Subject: [ANNOUNCE] libnetfilter_cttimeout 1.0.1 release
Message-ID: <YnO5/SN2W7IJ9mpM@orbyte.nwl.cc>
Mail-Followup-To: Phil Sutter <phil@netfilter.org>,
        netfilter <netfilter@vger.kernel.org>,
        netfilter-devel <netfilter-devel@vger.kernel.org>,
        netdev@vger.kernel.org, netfilter-announce@lists.netfilter.org,
        lwn@lwn.net
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="qhvWvKzBXMBwWaf7"
Content-Disposition: inline
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org


--qhvWvKzBXMBwWaf7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi!

The Netfilter project proudly presents:

        libnetfilter_cttimeout 1.0.1

This release contains only fixes:

* Warnings with automake-1.12
* Allow building on uclinux
* Fix building with clang

You can download the new release from:

https://netfilter.org/projects/libnetfilter_cttimeout/downloads.html#libnetfilter_cttimeout-1.0.1

In case of bugs, file them via:

* https://bugzilla.netfilter.org

Happy firewalling!

--qhvWvKzBXMBwWaf7
Content-Type: text/plain; charset=us-ascii
Content-Disposition: attachment;
	filename="changes-libnetfilter_cttimeout-1.0.1.txt"

Felix Janda (1):
  include: Sync with kernel headers

Gustavo Zacarias (1):
  configure: uclinux is also linux

Jan Engelhardt (2):
  build: remove unnecessary pkgconfig->config.status dependency
  build: resolve automake-1.12 warnings

Kevin Cernekee (1):
  Use __EXPORTED rather than EXPORT_SYMBOL

--qhvWvKzBXMBwWaf7--
