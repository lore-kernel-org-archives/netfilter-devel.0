From: Changli Gao <xiaosuo@gmail.com>
Subject: Re: [PATCH 0/7] [RFC] new cttimeout infrastructure
Date: Thu, 1 Mar 2012 20:51:56 +0800
Message-ID: <CABa6K_GKpkAiC7ae+-OwGG_b1iXyYD9+_xzF095XGTJ+e1aBWw@mail.gmail.com>
References: <1330483172-19159-1-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Cc: netfilter-devel@vger.kernel.org
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-vw0-f46.google.com ([209.85.212.46]:47248 "EHLO
	mail-vw0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759189Ab2CAMwR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 1 Mar 2012 07:52:17 -0500
Received: by vbbff1 with SMTP id ff1so398044vbb.19
        for <netfilter-devel@vger.kernel.org>; Thu, 01 Mar 2012 04:52:16 -0800 (PST)
In-Reply-To: <1330483172-19159-1-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Feb 29, 2012 at 10:39 AM,  <pablo@netfilter.org> wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
>
> You can find the user-space library:
>
> http://git.netfilter.org/cgi-bin/gitweb.cgi?p=libnetfilter_cttimeout.git;a=summary
>

IMHO we have too many such libraries. Why not combine all the library
into one named after libnf or libnetfilter?

-- 
Regards,
Changli Gao(xiaosuo@gmail.com)
