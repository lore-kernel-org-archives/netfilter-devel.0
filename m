From: Willy Tarreau <willy@w.ods.org>
Subject: Re: [PATCH]: latest netfilter+ipsec patches
Date: Fri, 5 Mar 2004 12:10:43 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040305111043.GA3908@alpha.home.local>
References: <401777B4.9020000@trash.net> <20040128103000.GP11761@sunbeam.de.gnumonks.org> <401D12B6.5030707@trash.net> <40301AB2.2030103@trash.net> <40337D63.6080602@trash.net> <20040218220337.GA3193@alpha.home.local> <40356624.6050209@trash.net> <4047AE0E.1080003@trash.net> <20040304231141.GA1782@alpha.home.local> <4047DC4E.8020309@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
   Harald Welte <laforge@netfilter.org>, Tom Eastep <teastep@shorewall.net>,
   Michal Ludvig <mludvig@suse.cz>, alex@samad.com.au, guillaume@morinfr.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Content-Disposition: inline
In-Reply-To: <4047DC4E.8020309@trash.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Patrick,

On Fri, Mar 05, 2004 at 02:47:58AM +0100, Patrick McHardy wrote:
 
> I attached a xfig file with a little picture of how it works, I hope
> it's understandable. The blue lines represent the flow as it happens
> without my patches, the red lines represent whats new. While drawing
> it, I noticed a bug, packets with their destination changed
> in nf_postxfrm_nonlocal may need to be delivered locally afterwards.

Thanks for the picture, indeed it's far better now ;-)

> Regarding loop-danger, I'm not totally sure yet, but I don't think
> that it would be triggerable by crafted packets but only by
> adventurous configurations. Multiple encapsulations are no error
> and they are limited to 4.

OK. Thanks for your clarifications, I understand better now.

Cheers,
Willy
