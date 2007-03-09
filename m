From: Amin Azez <azez@ufomechanic.net>
Subject: Re: [PATCH] chaostables
Date: Fri, 09 Mar 2007 11:54:17 +0000
Message-ID: <45F14AE9.90009@ufomechanic.net>
References: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr> <20070308131412.08d9973e@lxorguk.ukuu.org.uk> <Line.LNX.4.64.0703080955060.8029@d.namei> <Pine.LNX.4.61.0703081652310.2448@yvahk01.tjqt.qr> <45F044A0.50001@trash.net> <Pine.LNX.4.61.0703082112300.521@yvahk01.tjqt.qr> <45F12A69.1060406@ufomechanic.net> <Pine.LNX.4.61.0703091106280.8799@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Cc: Patrick McHardy <kaber@trash.net>,
	James Morris <jmorris@namei.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S964936AbXCILyd@vger.kernel.org>
In-Reply-To: <Pine.LNX.4.61.0703091106280.8799@yvahk01.tjqt.qr>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

* Jan Engelhardt wrote, On 09/03/07 10:19:
> Hello,
>
> On Mar 9 2007 09:35, Amin Azez wrote:
>   
>> * Jan Engelhardt wrote, On 08/03/07 20:26:
>>     
>>> xt_portscan needs to keep track of what packets the machine has already 
>>> seen. So on the first SYN, the connection is marked with "1". (Then we 
>>> send our SYN-ACK... and the connection turns ESTABLISHED.) The next 
>>> packet that is received will be an ACK or an RST. But it must come 
>>> _exactly after_ the SYN, so just using --tcp-flags ACK will not work. A 
>>> state which can be remembered is required. For that, an automaton is 
>>> used, whose state is saved in the connection mark.
>>>       
>> There would me more point in having this as a new match if it didn't
>> trample on the connection mark, but used it's own slot or flag-bit.
>>     
For the record, I support inclusion of this extension in general.
It is true to say "but a netfilter guru could craft together a sequence
of mark-consuming rules to do something somewhat similar" the same is
also somewhat true for connlimit (packet limits) and so on. The point of
this match is that people don't have to.
> Adding a member to the ip_conntrack/nf_conntrack and sk_buff struct would
> increase the struct sizes, and that would penalize users who do not intend
> to use xt_portscan.
>   
I understand what you say but it sounds a bit like saying: "but we
didn't make it very good because so few people would use it anyway"
which of course makes it even less attractive. I realise you have your
own interpretation but this is how it reads to me.
> I do not see why the packet/connection marks should not be used to record
> additional information
...
> Almost never I required connection marking myself 
I guessed as much. I use it heavily, with my xml rule generators.
> except for this
> portscanning automaton and perhaps a little MARK here and there for
> finely-tuned SNAT. Again, things might look different on your side(s).
>   
There's too many things fighting over the same few bits of the mark, and
in your case you are using it to track internal state of a connection
that has no relevance to the rest of the iptables/ebtables rules.

I'm suggesting that some of the people who would want to use the chaos
match, won't because of the mark issue.

This is not a new problem.

http://article.gmane.org/gmane.comp.security.firewalls.netfilter.devel/16217
> From: Tom Eastep <teastep <at> shorewall.net>
> Subject: Re: RFC: Disable defered bridge hooks by default
<http://news.gmane.org/find-root.php?message_id=%3c44AEFE20.3020307%40shorewall.net%3e>

>
> Once again, netfilter marks are the solution of last resort. This is
> becoming very painful for those of us who produce general Netfilter
> configuration tools. The situation is exacerbated by the fact that
> ebtables doesn't support modifying the mark value via logical AND/OR and
> the other fwmark consumers (tc, ip) don't allow a mask when testing the
> fwmark value.

I suggested one solution
http://article.gmane.org/gmane.comp.security.firewalls.netfilter.devel/16244

and Patrick McHardy has suggested using ct_extend.

I've not looked into this further because I'm too busy doing xml
versions of iptables, ebtables, iproute anc tc.

[There's an ip route<->xml at:
http://mailman.ds9a.nl/pipermail/lartc/2007q1/020376.html
iptables now has xml<-> convertor ]

Sam
