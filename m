From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD PATCH 6/8] Duplicate message to all existing instance
 of NFLOG.
Date: Tue, 25 Mar 2008 10:54:34 +0100
Message-ID: <47E8CBDA.7060502@netfilter.org>
References: <12051021893015-git-send-email-eric@inl.fr> <1205102190176-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:56449 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1752043AbYCYJyr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 25 Mar 2008 05:54:47 -0400
In-Reply-To: <1205102190176-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> A specific instance of NFLOG can now be use in multiple stacks. This is done
> by duplicating the interpretation of the message.

Applied. Thanks Eric.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
