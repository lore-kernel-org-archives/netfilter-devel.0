From: Jan Engelhardt <jengelh@inai.de>
Subject: Re: Formal submission of Xtables2
Date: Mon, 17 Dec 2012 21:51:10 +0100 (CET)
Message-ID: <alpine.LNX.2.01.1212171936410.18910@nerf07.vanv.qr>
References: <20121213142820.GA3489@1984> <alpine.LNX.2.01.1212131528410.1273@nerf07.vanv.qr> <20121213151615.GA6962@1984> <alpine.LNX.2.01.1212131623480.10856@nerf07.vanv.qr> <20121213172523.GB14333@1984> <alpine.LNX.2.01.1212131826040.5486@nerf07.vanv.qr>
 <20121217000841.GA9331@1984> <alpine.LNX.2.01.1212170214350.29351@nerf07.vanv.qr> <20121217095330.GA17148@1984> <alpine.LNX.2.01.1212171155090.25980@nerf07.vanv.qr> <20121217143018.GB1106@1984>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List
	<netfilter-devel@vger.kernel.org>,
	Netfilter user mailing list <netfilter@vger.kernel.org>,
	=?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
To: Pablo Neira Ayuso <pablo@netfilter.org>
Return-path: <netfilter-owner@vger.kernel.org>
In-Reply-To: <20121217143018.GB1106@1984>
Sender: netfilter-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Monday 2012-12-17 15:30, Pablo Neira Ayuso wrote:

>On Mon, Dec 17, 2012 at 02:01:07PM +0100, Jan Engelhardt wrote:
>[...]
>> >So far, I haven't see any *strong reason* to drop nftables code
>> 
>> In all fairness, I have never said anything about dropping nft.
>> I am focused on xt2, its inclusion and subsequent maintenance, because 
>> it resolves the ipt shortcomings in a way that I think appeals most to 
>> the userspace crowd.
>
>I'm still not convinced but I want find a short-term compromise
>solution for this which does not involve tons of email. We'll announce
>the netfilter workshop soon, likely to happen at Q1 2013 depending on
>availability of the organizer, but maybe Q2 2013 (but not later), I
>think it's the place to debate your proposal and nftables, of course.
>
>I will not get anything into mainline until then.

Delaying this for more months is not a good idea, I think.

The amount of patches will grow as more features are implemented. If
there is an objection to a patch, then this can have implications for
all those that follow (not rebase conflicts, but actual
invalidating), which gets more painful the larger the patchset is.
