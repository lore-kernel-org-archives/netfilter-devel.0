From: Alexey Dobriyan <adobriyan@gmail.com>
Subject: Re: [PATCH 1/7] netns ebtables: part 1
Date: Wed, 15 Oct 2008 08:25:09 +0400
Message-ID: <20081015042509.GL24058@x200.localdomain>
References: <20081015042014.GE24058@x200.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, netdev@vger.kernel.org,
	containers@osdl.org
To: kaber@trash.net
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from nf-out-0910.google.com ([64.233.182.187]:9253 "EHLO
	nf-out-0910.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751282AbYJOEWN (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 15 Oct 2008 00:22:13 -0400
Received: by nf-out-0910.google.com with SMTP id d3so1135642nfc.21
        for <netfilter-devel@vger.kernel.org>; Tue, 14 Oct 2008 21:22:12 -0700 (PDT)
Content-Disposition: inline
In-Reply-To: <20081015042014.GE24058@x200.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Oct 15, 2008 at 08:20:14AM +0400, Alexey Dobriyan wrote:
> One needs to add ".netns_ok = 1" to igmp_protocol to test all of this
> with ebtables() in netns.

Contains 80-column violations, I forgot about damn script again :^)
