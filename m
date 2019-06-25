Return-Path: <SRS0=l45K=UY=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-0.8 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	DKIM_VALID_AU,HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,
	SPF_PASS,UNPARSEABLE_RELAY,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id 54B6FC48BD6
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 11:33:14 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 0335F21670
	for <netfilter-devel@archiver.kernel.org>; Tue, 25 Jun 2019 11:33:13 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=kaechele.ca header.i=@kaechele.ca header.b="qLnj6j7I"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731249AbfFYLdN (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Tue, 25 Jun 2019 07:33:13 -0400
Received: from mail.fetzig.org ([54.39.219.108]:46598 "EHLO mail.fetzig.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730891AbfFYLdM (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
        Tue, 25 Jun 2019 07:33:12 -0400
Received: from authenticated-user (PRIMARY_HOSTNAME [PUBLIC_IP])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (2048 bits) server-digest SHA256)
        (No client certificate requested)
        (Authenticated sender: felix@fetzig.org)
        by mail.fetzig.org (Postfix) with ESMTPSA id 16C8A80DC9;
        Tue, 25 Jun 2019 07:33:07 -0400 (EDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kaechele.ca;
        s=kaechele.ca-201608; t=1561462387;
        bh=UhiI9k8MNaFPrGrQOZcXz4JZdlJ637GT8jnrpCVxZrM=;
        h=Subject:To:Cc:References:From:Date:In-Reply-To:From;
        b=qLnj6j7Iob+CQVxd+N1nNrIldEpr89zXeRy+ozjdC+PwI1c2gEf90FtWoS/cUfyfO
         1lZj9Z2yqAmLJM8Dvv3Zkv0WNs4ep3Pflu5cis8YOvwzB3GyGseqwSpqiM3tET8L5C
         Ug7lN9FSgsRUn6JRW/+0dDws87zmisPGmn7gQMgPFUSTc1/lxSX9WBcLauHHTzsa63
         /W6vUt+EbjndYJJW1wSiavVzZDjAGU0kvGwr4HM0DibgBzecd8kobz2VhPQlhdVOUc
         VXJDNKmFmvKd5nibPC2Z+ZNrdhtzFq4fz23Xf09YIgTCpBuXZySaFxgKfGq8uX5s7+
         HUGO6dXnUJpgw==
Subject: Re: [PATCH 08/13] netfilter: ctnetlink: Resolve conntrack L3-protocol
 flush regression
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, kristian.evensen@gmail.com
References: <20190513095630.32443-1-pablo@netfilter.org>
 <20190513095630.32443-9-pablo@netfilter.org>
 <0a4e3cd2-82f7-8ad6-2403-9852e34c8ac3@kaechele.ca>
 <20190624235816.vw6ahepdgvxhvdej@salvia>
 <4367f30f-4602-a4b6-a96e-35d879cc7758@kaechele.ca>
 <20190625080853.d6f523cimgg2u44v@salvia>
From:   Felix Kaechele <felix@kaechele.ca>
Message-ID: <0904a616-106c-91de-ed55-97973aa5c330@kaechele.ca>
Date:   Tue, 25 Jun 2019 07:33:05 -0400
MIME-Version: 1.0
In-Reply-To: <20190625080853.d6f523cimgg2u44v@salvia>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: de-DE
Content-Transfer-Encoding: 7bit
X-Virus-Scanned: clamav-milter 0.101.2 at pandora.fk.cx
X-Virus-Status: Clean
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

On 2019-06-25 4:08 a.m., Pablo Neira Ayuso wrote:
> As you describe, conntrack is a hashtable and the layer 3 protocol is
> part of the hash:
> 
> https://elixir.bootlin.com/linux/latest/source/net/netfilter/nf_conntrack_core.c#L188
> 
> so AF_UNSPEC cannot work.
> 
> There is no support for layer 3 wildcard deletion.

So in this case I'd like to propose two options:

1. the patch should be reverted and userspace fixed to properly request 
flushing of both AF_INET and AF_INET6 entries in the table when doing a 
full flush

2. both this patch as well as the initial patch "netfilter: ctnetlink: 
Support L3 protocol-filter on flush" should be reverted and a new 
approach should be made to implement that feature.

As it stands right now current kernel versions that are being released 
break userspace, which is unfortunate, because it forces me to run 
older, vulnerable kernels.

Regards,
   Felix
