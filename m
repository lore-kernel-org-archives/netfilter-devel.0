From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH netfilter: nft] Add the connmark meta_key
Date: Mon, 6 Jan 2014 17:04:00 +0000
Message-ID: <20140106170400.GA23002@macbook.localnet>
References: <1389027476-16837-1-git-send-email-kristian.evensen@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Kristian Evensen <kristian.evensen@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:55402 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755432AbaAFREE (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Mon, 6 Jan 2014 12:04:04 -0500
Content-Disposition: inline
In-Reply-To: <1389027476-16837-1-git-send-email-kristian.evensen@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Mon, Jan 06, 2014 at 05:57:56PM +0100, Kristian Evensen wrote:
> From: Kristian Evensen <kristian.evensen@gmail.com>
> 
> This patch enables connmark to be set/retrieved using meta
> expressions/statements.

Why would we add this to the meta expression instead of the ct expression?
