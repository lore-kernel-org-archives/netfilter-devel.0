From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] chaostables
Date: Fri, 9 Mar 2007 18:30:32 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703091523200.8799@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr>
	<20070308131412.08d9973e@lxorguk.ukuu.org.uk>
	<Line.LNX.4.64.0703080955060.8029@d.namei>
	<Pine.LNX.4.61.0703081652310.2448@yvahk01.tjqt.qr>
	<45F044A0.50001@trash.net>
	<Pine.LNX.4.61.0703082112300.521@yvahk01.tjqt.qr>
	<45F12A69.1060406@ufomechanic.net>
	<Pine.LNX.4.61.0703091106280.8799@yvahk01.tjqt.qr>
	<45F14AE9.90009@ufomechanic.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>, Alan Cox <alan@lxorguk.ukuu.org.uk>,
	James Morris <jmorris@namei.org>
To: Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45F14AE9.90009@ufomechanic.net>
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

Hello,


On Mar 9 2007 11:54, Amin Azez wrote:
>> Adding a member to the ip_conntrack/nf_conntrack and sk_buff struct
>> would increase the struct sizes, and that would penalize users who do
>> not intend to use xt_portscan.
>
>I understand what you say but it sounds a bit like saying: "but we didn't
>make it very good because so few people would use it anyway" which of
>course makes it even less attractive. I realise you have your own
>interpretation but this is how it reads to me.

I just gave the reason why I designed it the way it is now. If you 
really feel it needs to be changed, well, I don't really object to that. 
chaostables has only seen like.. 1 1/2 version announcements (urls to 
tarballs, no patches) to mailing lists, and except for the few users who 
definitely tried it (based on questions I received), there have not been 
any suggestions for changes yet, which either tells me that nobody is 
interested or everything is fine.

>> I do not see why the packet/connection marks should not be used to record
>> additional information
>...
>> Almost never I required connection marking myself 
>I guessed as much. I use it heavily, with my xml rule generators.
>> except for this
>> portscanning automaton and perhaps a little MARK here and there for
>> finely-tuned SNAT. Again, things might look different on your side(s).
>
>There's too many things fighting over the same few bits of the mark, and
>in your case you are using it to track internal state of a connection
>that has no relevance to the rest of the iptables/ebtables rules.
>
>I'm suggesting that some of the people who would want to use the chaos
>match, won't because of the mark issue.
>
>This is not a new problem.
>
>http://article.gmane.org/gmane.comp.security.firewalls.netfilter.devel/16217

	"""netfilter marks are the solution of last resort. This is
	becoming very painful for those of us who produce general
	Netfilter configuration tools.""" -Toam Eastep

I see. Thank you for the link. I think you are on the way to have me 
convinced.



Jan
-- 
