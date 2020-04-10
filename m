Return-Path: <SRS0=rxVU=52=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.9 required=3.0 tests=DKIM_ADSP_ALL,DKIM_INVALID,
	DKIM_SIGNED,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id B0A66C2BB1D
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Apr 2020 17:42:08 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 610D62064A
	for <netfilter-devel@archiver.kernel.org>; Fri, 10 Apr 2020 17:42:08 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=thorsten-knabe.de header.i=@thorsten-knabe.de header.b="dqsJrIgu"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726713AbgDJRmH (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Fri, 10 Apr 2020 13:42:07 -0400
Received: from mail.thorsten-knabe.de ([212.60.139.226]:59592 "EHLO
        mail.thorsten-knabe.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726740AbgDJRmG (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Fri, 10 Apr 2020 13:42:06 -0400
X-Greylist: delayed 970 seconds by postgrey-1.27 at vger.kernel.org; Fri, 10 Apr 2020 13:42:05 EDT
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=thorsten-knabe.de; s=dkim1; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:Date:Message-ID:To:Cc:Subject:From:Sender:Reply-To:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:In-Reply-To:References:List-Id:List-Help:List-Unsubscribe:
        List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=Zy3juXgWrgKtjlx4xnzpN8pF4qrR4S/JHsd1FcHXEQY=; b=dqsJrIgu5esEGgNk3FurR+dAdH
        DbliLWL5Y5tFlC5EarWbQqVFGmKoRA9ZF7GmABQIHhnsDV5i6qexuMdvqi4HqZUZWudsK42RHCq8d
        PpDchcXWW87aSr20HvOXowH55fHn0/O6Ik2wWP5B8N8EF7esYJVNxZ3NECsFALDUxNZHGRQ5kozbD
        kzC6A36J9NwxExrydTiATwQmLV+OKN484YJ4Yac/QqG8O3kyCYJmEIPcxkwiefaV3U7dSLPyNNlXB
        Ntb8BZ15KJHcapycLSWMsgMcNgXeDO36ngymZ2NgjCk1fuC9ZmsPnsZ2VUaIeuWRZMgrMEuQBRuuc
        cjotfVpw==;
Received: from tek01.intern.thorsten-knabe.de ([2a01:170:101e:1::a00:101])
        by mail.thorsten-knabe.de with esmtps (TLS1.2:ECDHE_RSA_AES_128_GCM_SHA256:128)
        (Exim 4.89)
        (envelope-from <linux@thorsten-knabe.de>)
        id 1jMxPZ-0004lG-GG; Fri, 10 Apr 2020 19:25:51 +0200
From:   Thorsten Knabe <linux@thorsten-knabe.de>
Subject: BUG: Anonymous maps with adjacent intervals broken since Linux 5.6
Cc:     sbrivio@redhat.com
To:     netfilter-devel@vger.kernel.org
Message-ID: <6d036215-e701-db81-d429-2c76856463ee@thorsten-knabe.de>
Date:   Fri, 10 Apr 2020 19:25:49 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8bit
Content-Language: en-US
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hello.

BUG: Anonymous maps with adjacent intervals are broken starting with
Linux 5.6. Linux 5.5.16 is not affected.

Environment:
- Linux 5.6.3 (AMD64)
- nftables 0.9.4

Trying to apply the ruleset:

flush ruleset

table ip filter {
  chain test {
    ip daddr vmap {
        10.255.1.0-10.255.1.255: accept,
        10.255.2.0-10.255.2.255: drop
    }
  }
}

using nft results in an error on Linux 5.6.3:

# nft -f simple.nft
simple.nft:7:19-5: Error: Could not process rule: File exists
    ip daddr vmap {

The same ruleset works flawlessly using Linux 5.5.16.

Changing the ruleset to:

flush ruleset

table ip filter {
  chain test {
    ip daddr vmap {
        10.255.1.0-10.255.1.254: accept,
        10.255.2.0-10.255.2.255: drop
    }
  }
}

(non adjacent intervals) makes the ruleset work again on Linux 5.6.3.

Reverting commit 7c84d41416d836ef7e533bd4d64ccbdf40c5ac70 from Linux
5.6.3 also fixes the problem.

Kind regards
Thorsten

-- 
___              
 |        | /                 E-Mail: linux@thorsten-knabe.de 
 |horsten |/\nabe                WWW: http://linux.thorsten-knabe.de 

