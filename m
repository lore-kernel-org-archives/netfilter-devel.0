From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 1/6] build: nfct and nflog can be disabled via configure
 option
Date: Thu, 30 Sep 2010 11:58:59 +0200
Message-ID: <4CA45F63.5000608@netfilter.org>
References: <1285116442-32490-1-git-send-email-eric@inl.fr> <1285116442-32490-2-git-send-email-eric@inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45973 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751603Ab0I3J7D (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 30 Sep 2010 05:59:03 -0400
In-Reply-To: <1285116442-32490-2-git-send-email-eric@inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 22/09/10 02:47, Eric Leblond wrote:
> This patch modifies the build system to be able to disable the compilation
> of NFCT and NFLOG input plugin. They are dependant of external libraries
> which can not be available on the system.
> Default is to compile these input plugin which make compilation behaviour
> conservative.

OK, if you need this go ahead.
