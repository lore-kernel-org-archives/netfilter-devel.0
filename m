From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 4/8] Don't call start function multiple time for
 a single plugin instance.
Date: Tue, 25 Mar 2008 09:48:59 +0100
Message-ID: <47E8BC7B.9040608@netfilter.org>
References: <12051021893015-git-send-email-eric@inl.fr> <12051021893106-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56864 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751031AbYCYItF (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 04:49:05 -0400
In-Reply-To: <12051021893106-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> When a plugin instance is used in multiple stack it is not necessary to
> call the start function for each stack.

Also applied. Thanks.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
