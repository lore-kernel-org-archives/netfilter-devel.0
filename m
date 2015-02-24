From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: libnetfilter_conntrack API is not working
Date: Tue, 24 Feb 2015 14:35:24 +0100
Message-ID: <20150224133524.GA3589@salvia>
References: <loom.20150224T113432-322@post.gmane.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org
To: Sourabh Rudrawar <sourabh.rudrawar@gmail.com>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:60707 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751436AbbBXNb5 (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 08:31:57 -0500
Content-Disposition: inline
In-Reply-To: <loom.20150224T113432-322@post.gmane.org>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 24, 2015 at 11:02:14AM +0000, Sourabh Rudrawar wrote:
> Hi, 
>  
>  I am using ubuntu-12.04-desktop version in Virtual Box.I am testing
> utils/conntrack_events.c using libnetfilter_conntrack API. But I get stuck on 
>     TEST: waiting for 10 events...
> And no event get caught even if I keep this running forever.

Did you modprobe nf_conntrack and nf_conntrack_ipv4 ?
