From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Formal submission of Xtables2
Date: Mon, 17 Dec 2012 00:57:51 +0100
Message-ID: <20121216235751.GA7528@1984>
References: <alpine.LNX.2.01.1212130601210.9421@nerf07.vanv.qr>
 <20121213110046.GA22337@1984>
 <20121214094141.GO2606@workstation>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter user mailing list <netfilter@vger.kernel.org>,
	netfilter-devel@vger.kernel.org
To: Andreas Herz <andi@geekosphere.org>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <20121214094141.GO2606@workstation>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi Andreas,

On Fri, Dec 14, 2012 at 10:41:41AM +0100, Andreas Herz wrote:
> On 13/12/12 at 12:00, Pablo Neira Ayuso wrote:
> > On Thu, Dec 13, 2012 at 07:00:07AM +0100, Jan Engelhardt wrote:
> > [...]
> > > Please consider for merging.
> > 
> > nftables and its compatibility layer already provide this and we will
> > not have to maintain two different netlink interfaces, which is too
> > much overhead.
> 
> Apart of your discussion (i think it's quite interesting although
> you might not agree), is there a summary of the status of nftables?
> The last time i read about it, while i was at the university, i
> thought it was dead.  I read that Patrick McHardy was the one
> pushing the project but never heard any news after 2010. Now i read
> that Pablo is taking care of it.

It's true that nftables suffered an hiatus in its development, but
we're back on it and there has been quite a lot of activity on it
recently. This is the kernel branch, you can check the changelog here:

http://1984.lsi.us.es/git/nf-next/log/?h=nf_tables8

And there's an iptables compatibility layer that is ready for IPv4,
you can find details here:

http://www.spinics.net/lists/netfilter-devel/msg23831.html

> So i would love to hear more details on the roadmap for nftables, might
> be interesting for me and my work here.

I understand you want to know more on the future of nftables, but
because the way I am, I prefer to skip "hot air" wording by now and
talk on code done anytime soon.

So I have to request some patience from you. We promise to deliver as
much information as possible once we are done with the core features.

Thanks.
