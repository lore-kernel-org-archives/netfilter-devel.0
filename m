From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: Formal submission of Xtables2
Date: Thu, 13 Dec 2012 15:28:20 +0100
Message-ID: <20121213142820.GA3489@1984>
References: <alpine.LNX.2.01.1212130601210.9421@nerf07.vanv.qr>
 <20121213110046.GA22337@1984>
 <alpine.LNX.2.01.1212131214100.20007@nerf07.vanv.qr>
 <20121213120509.GA26118@1984>
 <alpine.LNX.2.01.1212131405170.786@nerf07.vanv.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter user mailing list <netfilter@vger.kernel.org>
To: Jan Engelhardt <jengelh@inai.de>
Return-path: <netfilter-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <alpine.LNX.2.01.1212131405170.786@nerf07.vanv.qr>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, Dec 13, 2012 at 02:08:03PM +0100, Jan Engelhardt wrote:
> On Thursday 2012-12-13 13:05, Pablo Neira Ayuso wrote:
> >> >[...]
> >> >> Please consider for merging.
> >> >
> >> >nftables and its compatibility layer already provide this and we will
> >> >not have to maintain two different netlink interfaces, which is too
> >> >much overhead.
> >> 
> >> I refer you to our previous discussion on the topic
> >> for the justifications:
> >>
> >> http://www.spinics.net/lists/netfilter-devel/msg23919.html
> >
> >I don't think that feature-set provides compelling reasons to push
> >this mainstream.
> 
> Well, if not that, then what - documentation, code size?

Not only that. Xtables2 (in its feature-set) inherits many of the
design decisions that were taken while designing iptables back in the
late nineties.
