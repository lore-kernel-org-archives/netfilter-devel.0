Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id BC8DCC4332F
	for <netfilter-devel@archiver.kernel.org>; Wed, 12 Oct 2022 15:19:06 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230052AbiJLPTF (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Wed, 12 Oct 2022 11:19:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230060AbiJLPSm (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Wed, 12 Oct 2022 11:18:42 -0400
Received: from orbyte.nwl.cc (orbyte.nwl.cc [IPv6:2001:41d0:e:133a::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8217E313B
        for <netfilter-devel@vger.kernel.org>; Wed, 12 Oct 2022 08:18:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=nwl.cc;
        s=mail2022; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:Content-Type:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=UwN7/OgpvIP9fqjDCtw1cPTASScbPuai8xDexPQYqZs=; b=OL6F+t4C/YBol/7EzSdRT4SoTm
        5IFN5vu4Zc0ijiFAPD0s7E/O2AhAWUKUbrJ0G7xahGWDuC1NHEa0sa26eao6Cb1Girm68rbjzrfCs
        nnq0S/6BiNvu4UROr0/RMxUIIyJBOG0/4b10wa38jCuehxc2JQX5+uG8j2pUsoEoPlRVi6tLE1+Kl
        Ng8vOBtu89AWmFD9li06eEI6kcKWcMj7yF56T0kipWXAyTgXs3/oXRvadZcVRWUA6cEsmSvOnfkZz
        WWpoJim8H9x16sY+bEbYzxYFLI/CXW+JtChbxK678DGUm5TaWWuCuP+VxGm8PSBGpQKbxHClw89Ni
        DA+YNLCg==;
Received: from localhost ([::1] helo=xic)
        by orbyte.nwl.cc with esmtp (Exim 4.94.2)
        (envelope-from <phil@nwl.cc>)
        id 1oidV5-0002ox-Cs; Wed, 12 Oct 2022 17:18:27 +0200
From:   Phil Sutter <phil@nwl.cc>
To:     netfilter-devel@vger.kernel.org
Cc:     Jan Engelhardt <jengelh@inai.de>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [iptables PATCH v2 12/12] tests: *.t: Add missing all-one's netmasks to expected output
Date:   Wed, 12 Oct 2022 17:18:02 +0200
Message-Id: <20221012151802.11339-13-phil@nwl.cc>
X-Mailer: git-send-email 2.34.1
In-Reply-To: <20221012151802.11339-1-phil@nwl.cc>
References: <20221012151802.11339-1-phil@nwl.cc>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Signed-off-by: Phil Sutter <phil@nwl.cc>
---
 extensions/libip6t_NETMAP.t | 2 +-
 extensions/libipt_NETMAP.t  | 2 +-
 extensions/libxt_CONNMARK.t | 8 ++++----
 extensions/libxt_MARK.t     | 4 ++--
 4 files changed, 8 insertions(+), 8 deletions(-)

diff --git a/extensions/libip6t_NETMAP.t b/extensions/libip6t_NETMAP.t
index 043562d261243..79d47bf649720 100644
--- a/extensions/libip6t_NETMAP.t
+++ b/extensions/libip6t_NETMAP.t
@@ -1,4 +1,4 @@
 :PREROUTING,INPUT,OUTPUT,POSTROUTING
 *nat
 -j NETMAP --to dead::/64;=;OK
--j NETMAP --to dead::beef;=;OK
+-j NETMAP --to dead::beef;-j NETMAP --to dead::beef/128;OK
diff --git a/extensions/libipt_NETMAP.t b/extensions/libipt_NETMAP.t
index 31924b985cd6f..0de856f057d7d 100644
--- a/extensions/libipt_NETMAP.t
+++ b/extensions/libipt_NETMAP.t
@@ -1,4 +1,4 @@
 :PREROUTING,INPUT,OUTPUT,POSTROUTING
 *nat
 -j NETMAP --to 1.2.3.0/24;=;OK
--j NETMAP --to 1.2.3.4;=;OK
+-j NETMAP --to 1.2.3.4;-j NETMAP --to 1.2.3.4/32;OK
diff --git a/extensions/libxt_CONNMARK.t b/extensions/libxt_CONNMARK.t
index 79a838fefaa14..c9b2b4a504416 100644
--- a/extensions/libxt_CONNMARK.t
+++ b/extensions/libxt_CONNMARK.t
@@ -1,7 +1,7 @@
 :PREROUTING,FORWARD,OUTPUT,POSTROUTING
 *mangle
--j CONNMARK --restore-mark;=;OK
--j CONNMARK --save-mark;=;OK
--j CONNMARK --save-mark --nfmask 0xfffffff --ctmask 0xffffffff;-j CONNMARK --save-mark;OK
--j CONNMARK --restore-mark --nfmask 0xfffffff --ctmask 0xffffffff;-j CONNMARK --restore-mark;OK
+-j CONNMARK --restore-mark;-j CONNMARK --restore-mark --nfmask 0xffffffff --ctmask 0xffffffff;OK
+-j CONNMARK --save-mark;-j CONNMARK --save-mark --nfmask 0xffffffff --ctmask 0xffffffff;OK
+-j CONNMARK --save-mark --nfmask 0xfffffff --ctmask 0xffffffff;=;OK
+-j CONNMARK --restore-mark --nfmask 0xfffffff --ctmask 0xffffffff;=;OK
 -j CONNMARK;;FAIL
diff --git a/extensions/libxt_MARK.t b/extensions/libxt_MARK.t
index 2902a14f06742..ae026dbbce59f 100644
--- a/extensions/libxt_MARK.t
+++ b/extensions/libxt_MARK.t
@@ -1,7 +1,7 @@
 :INPUT,FORWARD,OUTPUT
 -j MARK --set-xmark 0xfeedcafe/0xfeedcafe;=;OK
--j MARK --set-xmark 0x0;=;OK
--j MARK --set-xmark 4294967295;-j MARK --set-xmark 0xffffffff;OK
+-j MARK --set-xmark 0x0;-j MARK --set-xmark 0x0/0xffffffff;OK
+-j MARK --set-xmark 4294967295;-j MARK --set-xmark 0xffffffff/0xffffffff;OK
 -j MARK --set-xmark 4294967296;;FAIL
 -j MARK --set-xmark -1;;FAIL
 -j MARK;;FAIL
-- 
2.34.1

