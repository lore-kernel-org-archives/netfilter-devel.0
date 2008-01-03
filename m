From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Ulogd2: fix autogen.sh
Date: Thu, 03 Jan 2008 18:41:07 +0100
Message-ID: <477D1E33.70807@netfilter.org>
References: <1199366555.11916.2.camel@khasse.inl.fr>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Eric Leblond <eric@inl.fr>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60855 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1751435AbYACRlZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 3 Jan 2008 12:41:25 -0500
In-Reply-To: <1199366555.11916.2.camel@khasse.inl.fr>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Hi Eric,

Eric Leblond wrote:
> This small patch adds a call to autoheader which is needed to compile
> ulogd2 from subversion.
> 
> By the way, it could be nice to do a call to:
>  svn rm aclocal.m4
> which should not in subversion.

Applied. And aclocal.m4 deleted.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
