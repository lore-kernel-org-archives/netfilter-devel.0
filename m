From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] don't copy the whole table to all the other CPUs
Date: Wed, 17 Nov 2010 15:56:29 +0100
Message-ID: <4CE3ED1D.4060308@trash.net>
References: <AANLkTinBSZPAMKb7J0aBb4_xBv_QPnXTZAE9c+8=cnHz@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: Changli Gao <xiaosuo@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46559 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932295Ab0KQO4a (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 17 Nov 2010 09:56:30 -0500
In-Reply-To: <AANLkTinBSZPAMKb7J0aBb4_xBv_QPnXTZAE9c+8=cnHz@mail.gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 17.11.2010 15:54, Changli Gao wrote:
> When reviewing the iptables code, I find there is one exact copy of
> table on every possible CPU for parallel processing. However, only
> counters are private, and the others are the same. It is a wast of
> memory. I know the current implementation maybe good for NUMA, but I
> don't think NUMA is common, and I doubt its benefit. I'll try to
> convert the code use one shared table, but private counters.

This was originally done because we used to keep the comefrom pointers
in the table and thus needed one private copy per CPU. This is not
done anymore since a few versions, so patches to get rid of the table
duplication are highly welcome.
