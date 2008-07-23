From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [ULOGD2 PATCH 0/4] Misc cleaning
Date: Wed, 23 Jul 2008 16:25:25 +0200
Message-ID: <48873F55.2000706@netfilter.org>
References: <> <1216812835-9851-1-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:59839 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751104AbYGWOZb (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jul 2008 10:25:31 -0400
In-Reply-To: <1216812835-9851-1-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Eric Leblond wrote:
> The main concern here is about IPFIX which is in really bad shape. I've fix
> some major error in one of the patch but it remains untested for now and I
> don't think it can work properly.

Indeed. It's broken Do you plan to look into this? If not, I'll fix it
myself. Please, let me know since I don't want to duplicate work. Do you
also plan to send me a patch to fix all those warnings?

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
