From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Why does conntrack need pthread ?
Date: Sat, 12 Jan 2008 16:04:59 +0100
Message-ID: <4788D71B.3070301@netfilter.org>
References: <d95317090801111211x4d9884f2wa6732ddf8c13d3be@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Gilad Benjamini <gilad.benjamini@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:42823 "EHLO us.es"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1759119AbYALPFZ (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Sat, 12 Jan 2008 10:05:25 -0500
In-Reply-To: <d95317090801111211x4d9884f2wa6732ddf8c13d3be@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Gilad Benjamini wrote:
> Why is conntrack compiled with pthread ?
> A simple test of removing it from compilation succeeded.
> Is it needed in non-standard configurations ?

It is a leftover from the very early conntrack-tools releases. I just
committed a patch to SVN to remove it. Thanks for noticing it.

-- 
"Los honestos son inadaptados sociales" -- Les Luthiers
