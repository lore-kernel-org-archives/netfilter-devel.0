From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [libnftnl PATCH] lookup: Fix an invalid read
Date: Wed, 16 Apr 2014 20:09:29 +0200
Message-ID: <20140416180929.GA5144@localhost>
References: <952227cde493df2637db10cbe8cf2f9b964d885c.1397556664.git.anarey@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Ana Rey <anarey@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:50355 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751457AbaDPSJf (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 16 Apr 2014 14:09:35 -0400
Content-Disposition: inline
In-Reply-To: <952227cde493df2637db10cbe8cf2f9b964d885c.1397556664.git.anarey@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 15, 2014 at 12:13:46PM +0200, Ana Rey wrote:
> Valgrind reports the following invalid read:
> 
> $ sudo valgrind ./nft-parsing-test -f ../jsonfiles/30-rule-lookup.json
> ==26664== Memcheck, a memory error detector
> ==26664== Copyright (C) 2002-2013, and GNU GPL'd, by Julian Seward et al.
> ==26664== Using Valgrind-3.9.0 and LibVEX; rerun with -h for copyright info
> ==26664== Command: ./nft-parsing-test -f ../jsonfiles/30-rule-lookup.json
> ==26664==
> ==26664== Invalid read of size 8
> ==26664==    at 0x4E45490: nft_rule_expr_lookup_set (lookup.c:50)

Applied, thanks Ana.
