Return-Path: <SRS0=n9X8=WO=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=HEADER_FROM_DIFFERENT_DOMAINS,
	MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,USER_AGENT_SANE_1 autolearn=no
	autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id A76C1C3A589
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Aug 2019 15:42:49 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 83210206DF
	for <netfilter-devel@archiver.kernel.org>; Sun, 18 Aug 2019 15:42:49 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726115AbfHRPms (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sun, 18 Aug 2019 11:42:48 -0400
Received: from mail105.syd.optusnet.com.au ([211.29.132.249]:57997 "EHLO
        mail105.syd.optusnet.com.au" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726089AbfHRPms (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sun, 18 Aug 2019 11:42:48 -0400
Received: from dimstar.local.net (unknown [114.72.91.7])
        by mail105.syd.optusnet.com.au (Postfix) with SMTP id A3AA1362264
        for <netfilter-devel@vger.kernel.org>; Mon, 19 Aug 2019 01:42:30 +1000 (AEST)
Received: (qmail 24150 invoked by uid 501); 18 Aug 2019 15:42:28 -0000
Date:   Mon, 19 Aug 2019 01:42:28 +1000
From:   Duncan Roe <duncan_roe@optusnet.com.au>
To:     Netfilter Development <netfilter-devel@vger.kernel.org>
Subject: git pull has stopped working
Message-ID: <20190818154228.GA10803@dimstar.local.net>
Mail-Followup-To: Netfilter Development <netfilter-devel@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Optus-CM-Score: 0
X-Optus-CM-Analysis: v=2.2 cv=FNpr/6gs c=1 sm=1 tr=0
        a=j7Z9DUGHOYSlcI8coM27+w==:117 a=j7Z9DUGHOYSlcI8coM27+w==:17
        a=kj9zAlcOel0A:10 a=FmdZ9Uzk2mMA:10 a=B4J5G_FS9iL-zi4UCdUA:9
        a=CjuIK1q_8ugA:10
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Hi,

As of tonight, whenever I try to do a git oull, this happens:

> 01:38:00$ git pull
> fatal: read error: Connection reset by peer
> 01:39:12$

Tried ebtables, iptables, libmnl, libnftnl & nftables.

It was working the day before yesterday,

Cheers ... Duncan.
