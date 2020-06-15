Return-Path: <SRS0=VCDi=74=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.6 required=3.0 tests=DKIM_INVALID,DKIM_SIGNED,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS
	autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 92CD8C433E0
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 12:34:57 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.kernel.org (Postfix) with ESMTP id 693012076A
	for <netfilter-devel@archiver.kernel.org>; Mon, 15 Jun 2020 12:34:57 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=fail reason="signature verification failed" (2048-bit key) header.d=infradead.org header.i=@infradead.org header.b="EzjEXnsQ"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729965AbgFOMe4 (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 15 Jun 2020 08:34:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48264 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729955AbgFOMez (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 15 Jun 2020 08:34:55 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60522C061A0E;
        Mon, 15 Jun 2020 05:34:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description;
        bh=7PZDg4jCzPxW5YIwZz6jai72YNhUOSrV8NAAvOuS8uI=; b=EzjEXnsQNJmyEoGtItnWE3dbp8
        O/Bso1kmXi5hV9UUaupbb5CH//hiui1DrLy5TxJ73AcaBq1m9m35Him7FyIZ3oifaXa6XLWOTjn9N
        SdW38NDwmhYxG4WK7RTmzZlY4He+nh8/awLJoDa0ceCvBZMij51jN0zYfVgz4GjVVmqAhxd8JQMV4
        pXsLBKiA6fy/GoolVDrkTUXTGRnqD9g8QFTyvfPvpFJXiRFKluo8YPGtdo0tPxFryq1txM6JkvjGq
        0k+am2VfuJyRMYzaBQyOY551WtFuYvucjplW9PXYFf6u3qN10DMGJ7BhfDLStqyTfMUBsZcEpXaFx
        i+5Y4bvQ==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jkoJz-0003d6-Pq; Mon, 15 Jun 2020 12:34:39 +0000
Date:   Mon, 15 Jun 2020 05:34:39 -0700
From:   Matthew Wilcox <willy@infradead.org>
To:     Christoph Hellwig <hch@lst.de>
Cc:     Al Viro <viro@zeniv.linux.org.uk>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ian Kent <raven@themaw.net>,
        David Howells <dhowells@redhat.com>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-security-module@vger.kernel.org,
        netfilter-devel@vger.kernel.org
Subject: Re: [PATCH 05/13] fs: check FMODE_WRITE in __kernel_write
Message-ID: <20200615123439.GT8681@bombadil.infradead.org>
References: <20200615121257.798894-1-hch@lst.de>
 <20200615121257.798894-6-hch@lst.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200615121257.798894-6-hch@lst.de>
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On Mon, Jun 15, 2020 at 02:12:49PM +0200, Christoph Hellwig wrote:
> We still need to check if the fѕ is open write, even for the low-level
> helper.

Do we need the analogous check for FMODE_READ in the __kernel_read()
patch?

> @@ -505,6 +505,8 @@ ssize_t __kernel_write(struct file *file, const void *buf, size_t count, loff_t
>  	const char __user *p;
>  	ssize_t ret;
>  
> +	if (!(file->f_mode & FMODE_WRITE))
> +		return -EBADF;
>  	if (!(file->f_mode & FMODE_CAN_WRITE))
>  		return -EINVAL;
>  
> -- 
> 2.26.2
> 
