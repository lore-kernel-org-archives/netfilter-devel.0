From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH nft v2] main: display errors through stderr
Date: Tue, 24 Feb 2015 20:01:40 +0100
Message-ID: <20150224190140.GA32754@salvia>
References: <1424802770-31213-1-git-send-email-pablo@netfilter.org>
 <20150224183505.GN3713@acer.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, alexandre@r42.ch
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:45841 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753580AbbBXS6I (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 13:58:08 -0500
Content-Disposition: inline
In-Reply-To: <20150224183505.GN3713@acer.localdomain>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Tue, Feb 24, 2015 at 06:35:05PM +0000, Patrick McHardy wrote:
> On 24.02, Pablo Neira Ayuso wrote:
> > Debugging still goes through stdout as Patrick requests.
> > 
> > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1000
> > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> 
> Thinking about it, EREC_INFORMATIONAL should also go to stdout I
> suppose. But since we don't have any of those yet, we can change
> it once we get the first message of this type.

I just remembered that bison is currently using stderr as output for
debugging.

We're also telling people to save their rulesets via:

        nft list ruleset > file

If debugging still goes to stdout this will cause them problems. Not
sure yet we should use stdout for debugging.
