From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 7/8] Add code for duplication of message in ULOG
Date: Tue, 25 Mar 2008 10:59:57 +0100
Message-ID: <47E8CD1D.80701@netfilter.org>
References: <12051021893015-git-send-email-eric@inl.fr> <12051021901513-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:54132 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751873AbYCYKAG (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 06:00:06 -0400
In-Reply-To: <12051021901513-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> In case of multiple usage of the same instance, this patch adds support for duplication
> of the message to be able to have multiple use of the same ULOG instance.

Applied. Thanks Eric. I have changed the comment on "feeding the birds"
whatever with one more descriptive :)

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
