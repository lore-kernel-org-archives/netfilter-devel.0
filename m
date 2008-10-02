From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH v2 3/6] netns ct: per-netns	net.netfilter.nf_conntrack_count
 sysctl
Date: Thu, 02 Oct 2008 10:00:59 +0200
Message-ID: <48E47FBB.20802@trash.net>
References: <48C01046.2070704@trash.net> <1220842990-30500-17-git-send-email-adobriyan@gmail.com> <48C623CA.9060803@trash.net> <20080909073245.GA7307@x200.localdomain> <48C62B1C.7070104@trash.net> <20080913105105.GD7440@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
	containers@lists.linux-foundation.org
To: Alexey Dobriyan <adobriyan@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:50916 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752433AbYJBIB7 (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 2 Oct 2008 04:01:59 -0400
In-Reply-To: <20080913105105.GD7440@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

Alexey Dobriyan wrote:
> Note, sysctl table is always duplicated, this is simpler and less
> special-cased.
>
>   

Applied.

