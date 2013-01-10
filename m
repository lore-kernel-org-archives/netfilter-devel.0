From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 6/7] netfilter: nf_tables: support 32bits-64bits x_tables
 compat
Date: Thu, 10 Jan 2013 17:12:36 +0100
Message-ID: <20130110161236.GD2178@macbook.localnet>
References: <1357831721-10182-1-git-send-email-pablo@netfilter.org>
 <1357831721-10182-6-git-send-email-pablo@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, tomasz.bursztyka@linux.intel.com
To: pablo@netfilter.org
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:58124 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754473Ab3AJQMk (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 10 Jan 2013 11:12:40 -0500
Content-Disposition: inline
In-Reply-To: <1357831721-10182-6-git-send-email-pablo@netfilter.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Thu, Jan 10, 2013 at 04:28:40PM +0100, pablo@netfilter.org wrote:
> From: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> This patch adds support for existing compat infrastructure in
> matches/targets.
> 
> This adds a new callback compat_to_blob that uses memcpy
> instead of copy_to_user.
> 

Alternatively we could use the existing compat callbacks and set_fs()
to avoid duplicating all of them.
