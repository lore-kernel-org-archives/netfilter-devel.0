From: Max Kellermann <max@duempel.org>
Subject: Re: [conntrack-utils PATCH r7285 07/11] use size_t
Date: Wed, 23 Jan 2008 13:37:46 +0100
Message-ID: <20080123123746.GA18405@swift.blarg.de>
References: <20080122141034.30077.12083.stgit@rabbit.intern.cm-ag> <20080122141051.30077.59792.stgit@rabbit.intern.cm-ag> <47973346.9060404@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from duempel.org ([78.31.71.42]:48607 "HELO duempel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1751009AbYAWMhr (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 23 Jan 2008 07:37:47 -0500
Content-Disposition: inline
In-Reply-To: <47973346.9060404@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 2008/01/23 13:29, Pablo Neira Ayuso <pablo@netfilter.org> wrote:
> I have kept remain signed since a malformed header can result in an
> overflow.

How?  And how will making it signed help?

Max

