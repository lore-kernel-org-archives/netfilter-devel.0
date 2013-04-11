From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 2/2] netfilter: ipset: hash:*net*: nomatch flag not
 excluded on set resize
Date: Thu, 11 Apr 2013 10:17:29 +0200
Message-ID: <20130411081729.GB3781@localhost>
References: <1365533840-23794-1-git-send-email-kadlec@blackhole.kfki.hu>
 <1365533840-23794-3-git-send-email-kadlec@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:46817 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753237Ab3DKIRe (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Thu, 11 Apr 2013 04:17:34 -0400
Content-Disposition: inline
In-Reply-To: <1365533840-23794-3-git-send-email-kadlec@blackhole.kfki.hu>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Apr 09, 2013 at 08:57:20PM +0200, Jozsef Kadlecsik wrote:
> If a resize is triggered the nomatch flag is not excluded at hashing,
> which leads to the element missed at lookup in the resized set.

Also applied, thanks.
