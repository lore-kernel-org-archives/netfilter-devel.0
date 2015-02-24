From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH nft v2] main: display errors through stderr
Date: Tue, 24 Feb 2015 19:18:02 +0000
Message-ID: <20150224191801.GP3713@acer.localdomain>
References: <1424802770-31213-1-git-send-email-pablo@netfilter.org>
 <20150224183505.GN3713@acer.localdomain>
 <20150224190140.GA32754@salvia>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, alexandre@r42.ch
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from stinky.trash.net ([213.144.137.162]:46940 "EHLO
	stinky.trash.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753131AbbBXTSH (ORCPT
	<rfc822;netfilter-devel@vger.kernel.org>);
	Tue, 24 Feb 2015 14:18:07 -0500
Content-Disposition: inline
In-Reply-To: <20150224190140.GA32754@salvia>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On 24.02, Pablo Neira Ayuso wrote:
> On Tue, Feb 24, 2015 at 06:35:05PM +0000, Patrick McHardy wrote:
> > On 24.02, Pablo Neira Ayuso wrote:
> > > Debugging still goes through stdout as Patrick requests.
> > > 
> > > Closes: https://bugzilla.netfilter.org/show_bug.cgi?id=1000
> > > Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>
> > 
> > Thinking about it, EREC_INFORMATIONAL should also go to stdout I
> > suppose. But since we don't have any of those yet, we can change
> > it once we get the first message of this type.
> 
> I just remembered that bison is currently using stderr as output for
> debugging.
> 
> We're also telling people to save their rulesets via:
> 
>         nft list ruleset > file
> 
> If debugging still goes to stdout this will cause them problems. Not
> sure yet we should use stdout for debugging.

I still think it makes sense since you explicitly requested it, its not
an error, its very useful to be able to pipe it to less directly and
it preserves order between regular output and debugging without doing
anything else.

I guess people simply shouldn't save their rulesets when enabling
debugging. Its not like we're doing it by default.
