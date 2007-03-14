From: Patrick McHardy <kaber@trash.net>
Subject: Re: NF structural changes (was: dangerous?)
Date: Wed, 14 Mar 2007 22:05:01 +0100
Message-ID: <45F8637D.3060600@trash.net>
References: <Pine.LNX.4.61.0703142148430.1199@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Amin Azez <azez@ufomechanic.net>,
	Hendrik Nordstrom <henrik@henriknordstrom.net>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.61.0703142148430.1199@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> As a result of the "dangerous? Setting mark in nat table" thread, I have 
> just drawn this idea of mine down, where:
> 
>  - filter and mangle tables are merged

We need to preserve compatibility (meaning we must keep the rerouting
in mangle), so I don't see the advantage over simply removing the
restrictions to mangle.

>  - filtering comes early, even before nat
>    (so that, for example, packets do not needlessy be MARKed, mangled,
etc.)

Would probably make life easier (no more -m conntrack --ctorigdst),
but I don't see how this could be changed without breaking rulesets.
