From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnetfilter_log 2/3] Set nflog_errno as needed.
Date: Tue, 30 Dec 2008 12:19:25 +0100
Message-ID: <495A03BD.4010805@netfilter.org>
References: <1230586404-24639-1-git-send-email-eric@inl.fr> <1230586404-24639-3-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56098 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751109AbYL3MFs (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 30 Dec 2008 07:05:48 -0500
In-Reply-To: <1230586404-24639-3-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> Some FIXME were put to fix some issues related to nflog_errno not being set. In both case, this was
> related to error treatment of libnfnetlink function. As these functions are setting errno to the
> correct value, this patch simply copy errno to nflog_errno in libnetfilter_log.

I doubt that anyone if using nf*_errno at this moment since t is not of
any help. We have no internal errno values different than those defined
in errno.h. I think it's better to use errno instead, at least for this
version of the API. See libnetfilter_conntrack.

For the upcoming version, we can introduce the nf*_errno again and
define internal errors. Same applies for libnetfilter_queue.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
