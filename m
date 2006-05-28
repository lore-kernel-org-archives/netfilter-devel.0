From: Patrick McHardy <kaber@trash.net>
Subject: Re: nth match
Date: Sun, 28 May 2006 14:00:02 +0200
Message-ID: <447990C2.3020705@trash.net>
References: <1148743183.2259.8.camel@murdegern.hindenburgdamm.example>	
	<447874D3.3030901@trash.net>	
	<1148750003.2259.32.camel@murdegern.hindenburgdamm.example>	
	<4478903A.3080402@trash.net>
	<1148775230.9778.11.camel@murdegern.hindenburgdamm.example>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Torsten Luettgert <t.luettgert@pressestimmen.de>
In-Reply-To: <1148775230.9778.11.camel@murdegern.hindenburgdamm.example>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-devel-bounces@lists.netfilter.org
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Torsten Luettgert wrote:
> Hmm. So does this mean pom is (in)officially dead?
> If new stuff doesn't go in there, and much of the old stuff is
> removed, and the rest of it will be merged in the foreseeable future,
> there's not much point in still maintaining it, right?

No, it will still be used for patches that we don't want to
put in mainline, but still have some interest in maintaining
and for patches maintained by other people.

> Personally, I'd regret that, because pom did at least supply
> a fine framework for writing own matches and targets.

It should be even easier to do this now since you can setup
your own repository and update it without having to send
patches to us, we just include the URL.
