From: Stephen Hemminger <stephen@networkplumber.org>
Subject: Re: [iptables 3/3] nft-shared: make compare_matches as public
Date: Fri, 7 Mar 2014 12:28:33 -0800
Message-ID: <20140307122833.0f01646c@nehalam.linuxnetplumber.net>
References: <1394220805-18021-1-git-send-email-giuseppelng@gmail.com>
	<1394220805-18021-4-git-send-email-giuseppelng@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Giuseppe Longo <giuseppelng@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail-pd0-f180.google.com ([209.85.192.180]:36892 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaCGU2h (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Fri, 7 Mar 2014 15:28:37 -0500
Received: by mail-pd0-f180.google.com with SMTP id v10so4478660pde.25
        for <netfilter-devel@vger.kernel.org>; Fri, 07 Mar 2014 12:28:37 -0800 (PST)
In-Reply-To: <1394220805-18021-4-git-send-email-giuseppelng@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Fri,  7 Mar 2014 20:33:25 +0100
Giuseppe Longo <giuseppelng@gmail.com> wrote:

> +bool compare_matches(struct xtables_rule_match *mt1,
> +		     struct xtables_rule_match *mt2)

any function exposed as global should have a name that uses
a prefix, something like nft_compare_matches or xt_compare_matches

The kernel is linked as single C application and this avoids future
name conflicts.
