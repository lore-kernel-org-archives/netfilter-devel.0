Return-Path: <netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 5403CC433F5
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Oct 2021 14:38:41 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 32EEA6105A
	for <netfilter-devel@archiver.kernel.org>; Sat, 16 Oct 2021 14:38:41 +0000 (UTC)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236224AbhJPOks (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Sat, 16 Oct 2021 10:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38402 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235150AbhJPOkr (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Sat, 16 Oct 2021 10:40:47 -0400
Received: from a3.inai.de (a3.inai.de [IPv6:2a01:4f8:10b:45d8::f5])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36B2BC061570
        for <netfilter-devel@vger.kernel.org>; Sat, 16 Oct 2021 07:38:39 -0700 (PDT)
Received: by a3.inai.de (Postfix, from userid 25121)
        id D06C058730FA4; Sat, 16 Oct 2021 16:38:36 +0200 (CEST)
Received: from localhost (localhost [127.0.0.1])
        by a3.inai.de (Postfix) with ESMTP id C51ED60C26CF0;
        Sat, 16 Oct 2021 16:38:36 +0200 (CEST)
Date:   Sat, 16 Oct 2021 16:38:36 +0200 (CEST)
From:   Jan Engelhardt <jengelh@inai.de>
To:     alireza sadeghpour <alireza0101sadeghpour@gmail.com>
cc:     netfilter-devel@vger.kernel.org
Subject: Re: xtable-addons document request
In-Reply-To: <04436e65-8c72-e2e5-d5ca-e45fd96575eb@gmail.com>
Message-ID: <p35o74s3-nnoq-2q1-788-62859q6q16@vanv.qr>
References: <04436e65-8c72-e2e5-d5ca-e45fd96575eb@gmail.com>
User-Agent: Alpine 2.25 (LSU 592 2021-09-18)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Saturday 2021-10-09 14:19, alireza sadeghpour wrote:

> 1. is there any tool in xtable-addons that can help me to change MTU field of
> the incoming / outgoing packets?

most packets have no MTU field.
