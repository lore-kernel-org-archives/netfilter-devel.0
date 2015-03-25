From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: ipset: Proposed improvements to the kernel code
Date: Wed, 25 Mar 2015 17:05:36 +0100
Message-ID: <20150325160536.GA4360@salvia>
References: <2984705.dCFJb2qqrb@tuxracer>
 <alpine.DEB.2.10.1503171459340.25136@blackhole.kfki.hu>
 <4532245.8hNB4lJHyg@tuxracer>
 <14722035.jXe0WcxyPC@tuxracer>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: netfilter-devel@vger.kernel.org, kadlec@blackhole.kfki.hu
To: Sergey Popovich <popovich_sergei@mail.ua>
Return-path: <netfilter-devel-owner@vger.kernel.org>
Received: from mail.us.es ([193.147.175.20]:41797 "EHLO mail.us.es"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932515AbbCYQBn (ORCPT <rfc822;netfilter-devel@vger.kernel.org>);
	Wed, 25 Mar 2015 12:01:43 -0400
Content-Disposition: inline
In-Reply-To: <14722035.jXe0WcxyPC@tuxracer>
Sender: netfilter-devel-owner@vger.kernel.org
List-ID: <netfilter-devel.vger.kernel.org>

On Wed, Mar 25, 2015 at 04:54:54PM +0200, Sergey Popovich wrote:
> > > > I did not say that you should do anything, I just give an option (like
> > > > branch) to let you quickly see changes I made if you wish. Maybe you
> > > > find them totally useless:)
> > > 
> > > I see - a branch costs nothing, so that's no problem. Then create a
> > > numbered list of the patches, put them in a tar file and let me know from
> > > where I can download it.
> > 
> > Thanks Jozsef, I have prepare patches for you and put link to the series.
> > 
> > http://ftp.payport.com.ua/users/sergey/public/netfilter-devel-2015031701.tar
> > 
> > These patches will be against nf-next for simplicity and I'm already rebase
> > them, so for first review just fresh nf-next will be needed.
> > 
> 
> Fixes to the first series. One of the most important is the fixes to set and 
> their data netlink dumping consistency. Just to complete series.
> 
> Netlink dumping consistency was inspired by the recent ipset git tree fixes
> to this problem. However I think there are other problems with consistent
> data dumping exists which my series tries to addess.
> 
> As the first series this is for nf-next git tree, not ipset git tree.
> 
> http://ftp.payport.com.ua/users/sergey/public/netfilter-devel-2015032501.tar

Could please send small batch (not more than 10 patches in one go,
please) to the mailing list so everyone can help in reviewing this?

Thanks.
