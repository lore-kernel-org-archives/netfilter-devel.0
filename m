From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] multiple changes/fixes
Date: Fri, 27 Aug 2004 22:08:54 +0200
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <412F94D6.8040906@trash.net>
References: <20040827133700.GT23981@eychenne.org> <412F5A3C.1000704@trash.net>
	<20040827162808.GA29915@eychenne.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Herve Eychenne <rv@wallfire.org>
In-Reply-To: <20040827162808.GA29915@eychenne.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Herve Eychenne wrote:

>On Fri, Aug 27, 2004 at 05:58:52PM +0200, Patrick McHardy wrote:
>
>>Would it be possible that you split the patch into logical changes
>>so it's easier to review ?
>>
>
>I was afraid someone would say that. Does someone know a good tool to
>split patches? I think of a X11 that would enable to drag and drop
>diff file portions to several new areas/patches, with an option that
>would automatically create one containing only whitespace changes.
>
Unfortunately, no. I use bitkeeper, patch and cut-n-paste for that, but
that's just my preference.

>
>Otherwise I guess I may not have the courage to do it. :-(
>
I hope you're still going to do it. I don't want to throw in a 70k
patch which touches stuff all over the place, and it's really hard
to judge which change has which purpose with just one big patch
that also reindents and reformats stuff. BTW:

-static int print_match(const struct ip6t_entry_match *e,
-                       const struct ip6t_ip6 *ip)
-{
+static int
+print_match(const struct ip6t_entry_match *e, const struct ip6t_ip6 *ip) {

the opening bracket should be on a seperate line.

Regards
Patrick
