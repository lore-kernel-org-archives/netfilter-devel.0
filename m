Return-Path: <netfilter-devel-owner@vger.kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 099D9C27C40
	for <netfilter-devel@archiver.kernel.org>; Thu, 24 Aug 2023 11:55:20 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236907AbjHXLys (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Thu, 24 Aug 2023 07:54:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236847AbjHXLyq (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Thu, 24 Aug 2023 07:54:46 -0400
Received: from mg.ssi.bg (mg.ssi.bg [193.238.174.37])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE9A1198B;
        Thu, 24 Aug 2023 04:54:43 -0700 (PDT)
Received: from mg.bb.i.ssi.bg (localhost [127.0.0.1])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTP id 5D59C91B2;
        Thu, 24 Aug 2023 14:54:42 +0300 (EEST)
Received: from ink.ssi.bg (ink.ssi.bg [193.238.174.40])
        by mg.bb.i.ssi.bg (Proxmox) with ESMTPS id 460FA91B1;
        Thu, 24 Aug 2023 14:54:42 +0300 (EEST)
Received: from ja.ssi.bg (unknown [213.16.62.126])
        by ink.ssi.bg (Postfix) with ESMTPSA id AD2F03C0325;
        Thu, 24 Aug 2023 14:54:39 +0300 (EEST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=ssi.bg; s=ink;
        t=1692878080; bh=qkt+qZ8EP4kk2R9+Z4BG5noU2/Z7WK3VK1joYnfj7fA=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=DP03lgWg66shJQXn+/zy04/JD4C0WoP2lDRUy+l0BobCc3UbAa6Fc/lzkINnY54hb
         Fwyk5aXQoSBsW8D9cY/d7l6Zm1ifnVTZMmSfjwCJxfUADJYr3hd9Gab9CFaKORG0Yg
         HVoGJ1yUPhBnrik8LFE+3mlyFjAxU1uMA3H4f18w=
Received: from ja.home.ssi.bg (localhost.localdomain [127.0.0.1])
        by ja.ssi.bg (8.17.1/8.17.1) with ESMTP id 37OBsdwg061800;
        Thu, 24 Aug 2023 14:54:39 +0300
Received: (from root@localhost)
        by ja.home.ssi.bg (8.17.1/8.17.1/Submit) id 37OBsbVg061791;
        Thu, 24 Aug 2023 14:54:37 +0300
From:   Julian Anastasov <ja@ssi.bg>
To:     stable@vger.kernel.org
Cc:     Simon Horman <horms@verge.net.au>, lvs-devel@vger.kernel.org,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        netfilter-devel@vger.kernel.org, Junwei Hu <hujunwei4@huawei.com>,
        Sishuai Gong <sishuai.system@gmail.com>
Subject: [PATCH -stable,4.14.y,4.19.y 0/1] ipvs: backport 1b90af292e71 and 5310760af1d4
Date:   Thu, 24 Aug 2023 14:53:53 +0300
Message-ID: <20230824115354.61669-1-ja@ssi.bg>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <2023082114-remix-cable-0852@gregkh>
References: <2023082114-remix-cable-0852@gregkh>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

	Hello,

	This patchset contains backport for
commit 1b90af292e71b20d03b837d39406acfbdc5d4b2a. It applies
to linux-4.14.y and linux-4.19.y and differs from original commit
for the zero/one values used for extra1/extra2.

	When applied, the concerned commit
5310760af1d4fbea1452bfc77db5f9a680f7ae47 can be cherry-picked and
it will apply cleanly on top of 1b90af292e71.

Junwei Hu (1):
  ipvs: Improve robustness to the ipvs sysctl

 net/netfilter/ipvs/ip_vs_ctl.c | 70 +++++++++++++++++-----------------
 1 file changed, 36 insertions(+), 34 deletions(-)

-- 
2.41.0


