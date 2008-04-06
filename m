From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 01/24] Fix compilation of iptables-static build
Date: Sun, 06 Apr 2008 17:31:25 +0200
Message-ID: <47F8ECCD.2010704@trash.net>
References: <1207495642-21055-1-git-send-email-jengelh@computergmbh.de> <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Jan Engelhardt <jengelh@computergmbh.de>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:37142 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752956AbYDFPbR (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Sun, 6 Apr 2008 11:31:17 -0400
In-Reply-To: <bd573e5e48763aa655cdb6e3f70a6f647c3868c7.1207495183.git.jengelh@computergmbh.de>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Jan Engelhardt wrote:
> Adjust the _INIT macro and thus fix the build/linking procedure of
> the monolithic do-it-all binary (iptables-static).
> 
> Also fix the Makefile since unfortunately, lib%.o does not seem to
> have a higher precedence than %.o
> ---
>  extensions/GNUmakefile.in |    6 +++---
>  1 files changed, 3 insertions(+), 3 deletions(-)

Applied.
