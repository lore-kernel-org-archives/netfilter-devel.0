From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] chaostables
Date: Fri, 9 Mar 2007 08:54:53 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703090822360.521@yvahk01.tjqt.qr>
References: <45F044A0.50001@trash.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: James Morris <jmorris@namei.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Netfilter Developer Mailing List
	<netfilter-devel@lists.netfilter.org>
To: kaber@trash.net
Return-path: <linux-kernel-owner+glk-linux-kernel-3=40m.gmane.org-S965771AbXCIH6O@vger.kernel.org>
In-Reply-To: <45F044A0.50001@trash.net>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

On Thu, 08 Mar 2007 18:15:12 +0100, Patrick McHardy wrote:
>>>>Index: linux-2.6.21-rc3/net/netfilter/xt_CHAOS.c
>>>>+	/* Equivalent to:
>>>>+	 * -A chaos -m statistic --mode random --probability \
>>>>+	 *         $reject_percentage -j REJECT --reject-with host-unreach;
>>>>+	 * -A chaos -m statistic --mode random --probability \
>>>>+	 *         $delude_percentage -j DELUDE;
[2nd one should have had -p tcp]
>>>>+	 * -A chaos -j DROP;
>>>>+	 */
>>>
>>>What does this do that can't be done by simply adding those individual 
>>>rules?
>>
>>It "wraps it all up", reducing the overall number of rules and user 
>>chains required in the filtering tables to implement the wanted logic. 
>>Reducing the number of filtering rules also reduces the time process a 
>>packet. These two are, in my opinion, a good thing.
>
>By that argument we could just codify every ruleset and put it in the
>kernel. Its three simple rules. There is no chance I'm going to take
>this part.

While that is indeed true, I think users will have a judgement (perhaps 
call it "first impression") that puts a certain set of NF rules into 
either of the two categories "this is fundamental/generic enough to 
warrant its own module" and "this does not". While

  -A INPUT -s 134.76.0.0/16 -p tcp --dport 22 -j ACCEPT;
  -A INPUT -p tcp --dport 80 -j ACCEPT;
  -A INPUT -j REJECT;

is clearly something that only applies to one machine only, perhaps a
little subnet, or at best, the servers on the company network, it is not
"for everyone". xt_CHAOS on the other hand was meant - if you want so - as
a replacement for DROP/REJECT and the default policy, e.g.:

	# Block all evil, even if from inside the house.
		-A INPUT -m evil -j CHAOS;
	# Ignore stray packets not directed at us
		-A INPUT -d mybase -m this -j ACCEPT;
	# Management console
		-A INPUT -s yourbase -m that -j ACCEPT;
	# Chain policy (instead, or supplemental to, -P INPUT DROP)
		-A INPUT -j CHAOS;

(-m evil, -m this and -m that are placeholders and are not seriously
considered to get their own kernel module anytime.)

For me, this falls under generic-enough, but your (and other people's) mileage
migt vary.


Thank you for the comments,

Jan
