From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] iptables: fix MASQUERADE section of man page
Date: Wed, 08 Jun 2011 14:44:42 +0200
Message-ID: <4DEF6EBA.7030903@trash.net>
References: <1307535742-24214-1-git-send-email-ddvlad@rosedu.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@vger.kernel.org
To: Vlad Dogaru <ddvlad@rosedu.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:44711 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752103Ab1FHMov (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 8 Jun 2011 08:44:51 -0400
In-Reply-To: <1307535742-24214-1-git-send-email-ddvlad@rosedu.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 08.06.2011 14:22, Vlad Dogaru wrote:
> The section about MASQUERADE specifies that it takes a single option,
> but in reality it takes two: --to-ports and --random.
> 

Applied, thanks.
