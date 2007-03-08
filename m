From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] chaostables
Date: Thu, 8 Mar 2007 21:26:13 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703082112300.521@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr>
 <20070308131412.08d9973e@lxorguk.ukuu.org.uk> <Line.LNX.4.64.0703080955060.8029@d.namei>
 <Pine.LNX.4.61.0703081652310.2448@yvahk01.tjqt.qr> <45F044A0.50001@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: James Morris <jmorris@namei.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S933307AbXCHU2y@vger.kernel.org>
In-Reply-To: <45F044A0.50001@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org


On Mar 8 2007 18:15, Patrick McHardy wrote:
>
>> Take xt_portscan as an example, which would require a minimum of 23 
>> filtering rules (which cannot reproduce the module's action in its 
>> fullest). 23 rules means we will be looping a bit in ipt_do_table() for 
>> a single packet, repeatedly checking for "-p tcp", i.e. calling into 
>> xt_tcpudp, checking for port ranges and perhaps other TCP fields that 
>> are never examined in xt_portscan.
>
>
>I'm guessing xt_portscan tries to detect and match on portscans, but
>its not obvious why it looks at and changes skb->mark and nfct->ctmark,
>so I suggest you start by explaining what it really does.

xt_portscan needs to keep track of what packets the machine has already 
seen. So on the first SYN, the connection is marked with "1". (Then we 
send our SYN-ACK... and the connection turns ESTABLISHED.) The next 
packet that is received will be an ACK or an RST. But it must come 
_exactly after_ the SYN, so just using --tcp-flags ACK will not work. A 
state which can be remembered is required. For that, an automaton is 
used, whose state is saved in the connection mark.

If you would like to find out more about the implementation, please have 
a look at http://jengelh.hopto.org/p/chaostables/fw.html section 3, 4, 
and perhaps 5.

As for the packet mark, refer to section 6. But for you: xt_portscan 
consists of "two" parts, one is "detect-and-mark" and the other is 
"match it". To have the following do the right thing

  -m portscan --cnscan  -j LOG --log-prefix "[evil user] "
  -m portscan --stealth -j LOG --log-prefix "[hideous evil user] "

the "detect-and-mark" code _must_ (in its common RFC meaning) only be 
executed once per packet.


>>>We already have the psd match for years, but decided against merging it.
>> 
>> On what basis? As far as I flew over psd's code, it uses a heuristic 
>> like "how often did that client recently connect" for match decision. 
>> (P2P clients randomly port knocking, anyone?) I would not think of that 
>> as a reliable way to tell portscans either. However, half-open TCP 
>> connect for example is a more clear action to define a portscan.
>
>The question is what we gain by being able to detect portscans.

You have a point with that. But then we could argue on hours about what 
we gain with life.

>So far my opinion is thats its close to nothing. Besides that,
>it should be possible to do this by using the recent match.

Perhaps. I'll just provide this little example of what is good for to 
check for portscans:

  -N block_it
  -A block_it -m recent --name block_it --update --seconds 60;

  -A INPUT -m portscan --cnscan -j block_it;
  -A INPUT -m recent --name block_it --rcheck -j DROP;

that is, to drop everything from evil hosts doing half-open scans for 
some time.

[ Ok, I used "recent", now I don't get what you meant by "Besides that,
  it should be possible to do this by using the recent match." -
  recent alone does not check for half-opens, nor connect-scans. It 
  checks for recentness of anything. I hope you can clarify. ]



Thank you,
Jan
-- 
