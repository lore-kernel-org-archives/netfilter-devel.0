Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-16.8 required=3.0 tests=BAYES_00,
	HEADER_FROM_DIFFERENT_DOMAINS,INCLUDES_CR_TRAILER,INCLUDES_PATCH,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,URIBL_BLOCKED,USER_AGENT_GIT
	autolearn=ham autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 0CCA6C433DB
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Jan 2021 10:16:36 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id D691C6146D
	for <netfilter-devel@archiver.kernel.org>; Sat, 30 Jan 2021 10:16:35 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232185AbhA3KQK (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 30 Jan 2021 05:16:10 -0500
Received: from mailrelay116.isp.belgacom.be ([195.238.20.143]:15155 "EHLO
        mailrelay116.isp.belgacom.be" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232169AbhA3KPV (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 30 Jan 2021 05:15:21 -0500
IronPort-SDR: RdpViPmviSSWlOLuAxi3tFFniD8efm2cCJpbSK+JEQ+2yXvcc8zRCfGKeRxk4ziEmRPiyJXcXe
 r2nBVAG/JtAw+Df1ji8RizCjDvtdMQtbYhmf+6j769xNXr9PVA399ELb2+ivZnW3kvqWlVajqg
 KCSUXkqjrmC3ZwoEsi62YfEGUcgVLizZnkrvoaDERoPZgmY2px9I8zo44IuKE9EeLyRtjXbJvv
 IdjUwNWsVAm472rRD81Rlf4ZNwFPQJghUa3sUgJxB1S9reYlbbD6SUoAAkMgm3W1Lw2zBZ+suZ
 9Xs=
X-Belgacom-Dynamic: yes
IronPort-PHdr: =?us-ascii?q?9a23=3A0ch69xCygGS8G+JHZEIyUyQJP3N1i/DPJgcQr6?=
 =?us-ascii?q?AfoPdwSP36rsiwAkXT6L1XgUPTWs2DsrQY0ruQ6PyrADZIoc7Y9ixbL9oUD1?=
 =?us-ascii?q?5NoP5VtjRoONSCB0z/IayiRA0BN+MGamVY+WqmO1NeAsf0ag6aiHSz6TkPBk?=
 =?us-ascii?q?e3blItdaz6FYHIksu4yf259YHNbAVUnjq9Zq55IAmroQnLucQanI9vJrw/xx?=
 =?us-ascii?q?bGrXdEZvpazn5sKV6Pghrw/Mi98INh/ihKp/4t68tMWrjmcqolSrBVEC4oOH?=
 =?us-ascii?q?0v6s3xshnDQwqP5n8CXWgTjxFFHQvL4gzkU5noqif1ufZz1yecPc3tULA7Qi?=
 =?us-ascii?q?+i4LtxSB/pkygIKTg0+3zKh8NqjaJbpBWhpwFjw4PRfYqYOuZycr/bcNgHQ2?=
 =?us-ascii?q?dKQ8RfWDFbAo6kb4UBEfcPM+hboYf6qFQAogCzCRWvCe711jNFnGP60bE83u?=
 =?us-ascii?q?88EQ/GxgsgH9cWvXrUttr6L6YSXvqzzKLVzTvDde1Z1irj54jScxAuvfKMVq?=
 =?us-ascii?q?93fMrf00YgDA3Fg06LqYzmPzKV0PoCs3SB4+V7S+2ikmgqoBx+rTaz3MkjkJ?=
 =?us-ascii?q?XJhp4LxVDe8yV02Ig7KN68RUB7YNOpEIVcui+aOYZrXs8uXn1ktSc1xLMJpJ?=
 =?us-ascii?q?O2cjYHxYknyhPddfGJfJSE7BzsWuuVITl2hGxpdba5ih2v8kag0vXxW82p3F?=
 =?us-ascii?q?pQsyZIkcfAumoQ2xHS6sWLUOZx80an1D2SzQ7c8PtELloxlafDLp4hxaM/mY?=
 =?us-ascii?q?QLvETYGy/2hF32jKiLdkU44uSo6/roYrHhppKEM490jR3xPb4qmsy/BuQ4KR?=
 =?us-ascii?q?QOU3Kf+eS7yLLs50n5T6hNjv0ziKbZsZbaKdwapq6/HQBVzp4u5hKiAzu8zd?=
 =?us-ascii?q?gVnmcLIEhYdB+Gj4XlIUzCLfHgAfe6mVuskTNrx/7cPr3mB5XANnbDn636cr?=
 =?us-ascii?q?Zz8ENc0wkzzNBZ551KFrENOun8VVHpuNzCEhA5KxC0w/rgCNhlzoMRQ3mAAq?=
 =?us-ascii?q?ueMK7Jt1+H+P4vI+eNZI8RpDbyNeIl6+TpjX8jll8XZbOp0ocPaHCkAvRmJF?=
 =?us-ascii?q?2UYXn2jdgcFWcFoBYxQffsiFKcTT5TaXeyX6Yg5j4lEoKqF4DDRpqigLaZxi?=
 =?us-ascii?q?e0AoVWZnxaClCLCXroeYuFVuwXaCKOOM9hliILVb67R4A8yx6krBX6xKZ/Lu?=
 =?us-ascii?q?rI5i0Ysoru1N5r6O3PmxEy9Dh0D9iD3GGXVm17g30HRyEo06B7ukF91FiD3r?=
 =?us-ascii?q?Zig/BCFtxc+elJUgEkOp7Y1eB6DMryWg3ZdNeTVFmmWsmmAS02Tt8p39AOZF?=
 =?us-ascii?q?x9FMu+jh/dxSWqBqQYl7qVC5wo/KLc3nzxJ9pjxHbczqUhiEMmQsRXP228mq?=
 =?us-ascii?q?F/7xTTB5LOk0iBkKaqcaUc3DDT+2eZ12aOp1tXUAh/UajeXHAfYFfWosr95k?=
 =?us-ascii?q?/YU7CuDrEnOBNbycGeMqtKdsHpjVJeSfftItvReGyxlnyrBRaLxrKMapTle3?=
 =?us-ascii?q?kH0CrGFkdX2zwUqG6PPww5LiGsv2zfCCBjDxToeUyouep3pHe2RWcywh2Ebk?=
 =?us-ascii?q?l92qDz/QQawbSSVNsIwqgAtSFnpzgnMky62of4AtCBrgwpUr9Rbd4n4VxEnT?=
 =?us-ascii?q?bXvgZzFoejPqZvmhgUflIk7AvVyxxrB9AYwoARp3QwwV8qJA=3D=3D?=
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-Anti-Spam-Result: =?us-ascii?q?A2B8AAC3MBVg/xCltltiHQEBAQEJARI?=
 =?us-ascii?q?BBQUBR4E2BgELAYEdggNWZY1EiQsBiXSGEIoLgXwLAQEBAQEBAQEBJBEBAgQ?=
 =?us-ascii?q?BAYRKgXsmNgcOAgMBAQEDAgUBAQYBAQEBAQEFBAGGGEaCOCKDUgEjI4E/EoM?=
 =?us-ascii?q?mAYJhKbVhhBWBRIM5gUSBOAGIWIRlQYFBP4ERg1eEBYYyBIJHATxRgXC5YYM?=
 =?us-ascii?q?AgymEf4EKkjQPIoMukCCPNpQoo2YBggpNIBiDJAlHGQ2ca0MwNwIGCgEBAwl?=
 =?us-ascii?q?XAT0BiDmCRgEB?=
X-IPAS-Result: =?us-ascii?q?A2B8AAC3MBVg/xCltltiHQEBAQEJARIBBQUBR4E2BgELA?=
 =?us-ascii?q?YEdggNWZY1EiQsBiXSGEIoLgXwLAQEBAQEBAQEBJBEBAgQBAYRKgXsmNgcOA?=
 =?us-ascii?q?gMBAQEDAgUBAQYBAQEBAQEFBAGGGEaCOCKDUgEjI4E/EoMmAYJhKbVhhBWBR?=
 =?us-ascii?q?IM5gUSBOAGIWIRlQYFBP4ERg1eEBYYyBIJHATxRgXC5YYMAgymEf4EKkjQPI?=
 =?us-ascii?q?oMukCCPNpQoo2YBggpNIBiDJAlHGQ2ca0MwNwIGCgEBAwlXAT0BiDmCRgEB?=
Received: from 16.165-182-91.adsl-dyn.isp.belgacom.be (HELO localhost.localdomain) ([91.182.165.16])
  by relay.skynet.be with ESMTP; 30 Jan 2021 11:14:38 +0100
From:   Fabian Frederick <fabf@skynet.be>
To:     pablo@netfilter.org, kadlec@netfilter.org, fw@strlen.de
Cc:     netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        oliver.sang@intel.com, fabf@skynet.be
Subject: [PATCH 1/1 nf] selftests: netfilter: fix current year
Date:   Sat, 30 Jan 2021 11:14:25 +0100
Message-Id: <20210130101425.18426-1-fabf@skynet.be>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

use date %Y instead of %G to read current year
Problem appeared when running lkp-tests on 01/01/2021

Fixes: 48d072c4e8cd ("selftests: netfilter: add time counter check")
Reported-by: kernel test robot <oliver.sang@intel.com>
Signed-off-by: Fabian Frederick <fabf@skynet.be>
---
 tools/testing/selftests/netfilter/nft_meta.sh | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tools/testing/selftests/netfilter/nft_meta.sh b/tools/testing/selftests/netfilter/nft_meta.sh
index 087f0e6e71ce..f33154c04d34 100755
--- a/tools/testing/selftests/netfilter/nft_meta.sh
+++ b/tools/testing/selftests/netfilter/nft_meta.sh
@@ -23,7 +23,7 @@ ip -net "$ns0" addr add 127.0.0.1 dev lo
 
 trap cleanup EXIT
 
-currentyear=$(date +%G)
+currentyear=$(date +%Y)
 lastyear=$((currentyear-1))
 ip netns exec "$ns0" nft -f /dev/stdin <<EOF
 table inet filter {
-- 
2.25.1

