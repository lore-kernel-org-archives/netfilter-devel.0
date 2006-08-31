From: "Marco Berizzi" <pupilla@hotmail.com>
Subject: Re: statistic match support in iptables snapshots
Date: Thu, 31 Aug 2006 16:11:27 +0200
Message-ID: <BAY103-F3931E616D265D048A20406B23F0@phx.gbl>
References: <44F6E395.1000709@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; format=flowed
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <44F6E395.1000709@trash.net>
To: kaber@trash.net
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

Patrick McHardy wrote:

>Marco Berizzi wrote:
> > I would like to test the new statistic match
> > before linux 2.6.18 final. May be possible
> > to include the support library in an iptables
> > daily snapshots?
>
>I've just added it SVN, it should appear in the next snapshot.

oohh thanks a lot for the quick response.
Sorry for breaking you again: is not possible
having multiple counters with 'nth mode'?
I have taken a look at the source code:

"statistic match v%s options:\n"
" --mode mode                    Match mode (random, nth)\n"
" random mode:\n"
" --probability p                Probability\n"
" nth mode:\n"
" --every n                      Match every nth packet\n"
" --packet p                     Initial counter value (0 <= p <= n-1, 
default 0)\n"
"\n",
