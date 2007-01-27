From: Patrick McHardy <kaber@trash.net>
Subject: Re: PANIC: divide by zero in xt_connbytes
Date: Sat, 27 Jan 2007 17:36:02 +0100
Message-ID: <45BB7F72.5010900@trash.net>
References: <45AF5318.8040204@outerspace.dyndns.org>
	<200701181522.37984@nienna> <45BA3930.9070804@trash.net>
	<200701262111.44400@nessa>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org,
	Pablo Neira Ayuso <pablo@netfilter.org>
To: KOVACS Krisztian <hidden@balabit.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200701262111.44400@nessa>
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

KOVACS Krisztian wrote:
> On Friday 26 January 2007 18:24, Patrick McHardy wrote:
> 
>>I'm wondering what value to use when packets == 0 though,
>>it can't happen for the first packet of a connection since
>>it has already been accounted for before we can match, so
>>the packets counter must have overflown at least once (and
>>the byte counter at least as often as the packet counter).
> 
> 
>   Ok, but what happens if you match on reply packets? I'm quite sure 
> something like this will trigger a crash as soon as a new connection 
> arrives:
> 
> # iptables -A INPUT -m connbytes --connbytes 100: --connbytes-dir \ 
> reply --connbytes-mode avgpkt -j ACCEPT


You're right of course, I didn't think of that. The patches fixes
this as well (using 0 as average value, which at least in the
"no packets seen so far" case makes sense), but I'm going to fix
the changelog.
