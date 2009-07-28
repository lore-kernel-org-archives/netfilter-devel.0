From: Patrick McHardy <kaber@trash.net>
Subject: Re: nftables: problem with sets (Object not found)
Date: Tue, 28 Jul 2009 14:23:22 +0200
Message-ID: <4A6EEDBA.3010505@trash.net>
References: <4A69FCC3.1070404@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Netfilter Developer Mailing List <netfilter-devel@vger.kernel.org>
To: "Christoph A." <casmls@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:51343 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbZG1MXY (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 28 Jul 2009 08:23:24 -0400
In-Reply-To: <4A69FCC3.1070404@gmail.com>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Christoph A. wrote:
> when trying to use sets ({ ..., ...}) I get the error "Object not found".
> 
> This is my testscript:
> #! /usr/local/sbin/nft -f
> 
> 
> ...
> In file included from internal:0:0-0:
> ./set_problem:12:17-42: Error: Could not add rule: Object not found
> 		tcp dport { 22, 80} accept
>                 ^^^^^^^^^^^^^^^^^^^^^^^^^^
> 
> Am I missing something in the kernel or do I have a syntax error in my
> rules?
> (kernel config attached)

I never pushed out the userspace changes for the new set API.
I just pushed out all the changes that should be needed, please
update your trees and try again.

