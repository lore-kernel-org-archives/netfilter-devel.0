Return-Path: <SRS0=7PQj=WB=vger.kernel.org=netfilter-devel-owner@kernel.org>
X-Spam-Checker-Version: SpamAssassin 3.4.0 (2014-02-07) on
	aws-us-west-2-korg-lkml-1.web.codeaurora.org
X-Spam-Level: 
X-Spam-Status: No, score=-2.3 required=3.0 tests=DKIM_SIGNED,DKIM_VALID,
	HEADER_FROM_DIFFERENT_DOMAINS,MAILING_LIST_MULTI,SPF_HELO_NONE,SPF_PASS,
	USER_AGENT_SANE_1 autolearn=no autolearn_force=no version=3.4.0
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
	by smtp.lore.kernel.org (Postfix) with ESMTP id C420FC0650F
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Aug 2019 06:02:44 +0000 (UTC)
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.kernel.org (Postfix) with ESMTP id 9CDCE206C1
	for <netfilter-devel@archiver.kernel.org>; Mon,  5 Aug 2019 06:02:44 +0000 (UTC)
Authentication-Results: mail.kernel.org;
	dkim=pass (2048-bit key) header.d=resnulli-us.20150623.gappssmtp.com header.i=@resnulli-us.20150623.gappssmtp.com header.b="nGb8EYn0"
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727294AbfHEGCl (ORCPT
        <rfc822;netfilter-devel@archiver.kernel.org>);
        Mon, 5 Aug 2019 02:02:41 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:56279 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727225AbfHEGCl (ORCPT
        <rfc822;netfilter-devel@vger.kernel.org>);
        Mon, 5 Aug 2019 02:02:41 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so73458592wmj.5
        for <netfilter-devel@vger.kernel.org>; Sun, 04 Aug 2019 23:02:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=rYbLHeGEkazMYqZpHw+axOUdiO9DJFjeR3HG13iSHYE=;
        b=nGb8EYn0j+RQBxVSCa1n1EyFmtdIfEuLUCX2KAp9y0Ioe/1pjs+rjP2GGOIpvBpzMY
         n/D1x6IGmixX2PpCZiPmcONWrwWI2udkFDZ8R5Z3zdrd5yR9DKwu7bR1PJgyxIXOfhQF
         od4We0x8lMkeEZov/thQXa6mbbBlKudqU86TQ3drDCtTZj/tWyA1O+YmjN7xpvojdifk
         iVHCBCpjUz7Z+x0mGaD5LxGTSJwMJtqBMc09oq8shNPs5JWdHCWpX2EPTsMwVjGs03Tn
         4H5gKNhaLlrjL2lsOE4zwU1i3VVGrxPHWp1wqstYEEVwNDkvY5OswQr+bbFZcEhCzcF9
         DhFA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=rYbLHeGEkazMYqZpHw+axOUdiO9DJFjeR3HG13iSHYE=;
        b=pzfNTNCW5SKePIyfSE2uDX+yzEMaV+9oQxLMdxtZwHC8dIwi9DpmNA+VkVtcH/iMdW
         6RKkC0JaBFPkWm5/Wws1tx1iw4q/neGcsYrk4e9iZZThsy4LQVW8ac5OBBebceLRM2s/
         J4A3A1KSSOvlDWRPYJc1Xpm7N8U7tJofGsjB8CeBs5bcZ0A/TeXjLXYDww9yac+atvDx
         J/MkpTEXzz463Yqvo474pkX7HLMj5i7oEW7XAhQdCA3BIA02ktPGPzAyKc4uBXw7hjHm
         qRArKfsGwgq5rkWDWEuAjvDUmDLZvCUCOA67qYLEyyU2R4EK59xjkuPn+PxmakpRzrxQ
         o5tw==
X-Gm-Message-State: APjAAAX0vDWw8lNrvOfWlHaZ5eat/38j9L4ZD8iv+S1Qgje4AVZji7PH
        3H8q99xX6Ba/qIPOkihwqTh/ig==
X-Google-Smtp-Source: APXvYqwsDzjnqn7kQhQNISPjmml7diURISWzFQnEUhyPflTbdqCa8FD5Jm797JM/YiXzUIO52ZD5wQ==
X-Received: by 2002:a7b:c651:: with SMTP id q17mr15334256wmk.136.1564984959650;
        Sun, 04 Aug 2019 23:02:39 -0700 (PDT)
Received: from localhost (jirka.pirko.cz. [84.16.102.26])
        by smtp.gmail.com with ESMTPSA id g8sm85255642wmf.17.2019.08.04.23.02.39
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sun, 04 Aug 2019 23:02:39 -0700 (PDT)
Date:   Mon, 5 Aug 2019 08:02:38 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     wenxu@ucloud.cn
Cc:     pablo@netfilter.org, fw@strlen.de, jakub.kicinski@netronome.com,
        netfilter-devel@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 3/6] cls_api: add flow_indr_block_call function
Message-ID: <20190805060238.GB2349@nanopsycho.orion>
References: <1564628627-10021-1-git-send-email-wenxu@ucloud.cn>
 <1564628627-10021-4-git-send-email-wenxu@ucloud.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1564628627-10021-4-git-send-email-wenxu@ucloud.cn>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netfilter-devel-owner@vger.kernel.org
Precedence: bulk
List-ID: <netfilter-devel.vger.kernel.org>
X-Mailing-List: netfilter-devel@vger.kernel.org

Re subject. You don't have "v5" in this patch. I don't understand how
that happened. Do you use --subject-prefix in git-format-patch?
