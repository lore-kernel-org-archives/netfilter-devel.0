From: Biermann-Roemke@t-online.de (=?ISO-8859-1?Q?Karsten_R=F6mke?=)
Subject: Re: libiptc - frustrating
Date: Fri, 03 Oct 2003 13:08:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3F7D58CA.2000407@hhb.bonn.de>
References: <3F7C4919.8060800@hhb.bonn.de> <20031002201344.GF5758@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org



Harald Welte schrieb:
>>Question: how can I insert a rule from a running daemon in the fastest way:
>>1) calling a system("iptables ..."), don't know if the syntas is correct
>>2) doing the work again of analyzing the source code again
>>3) linking iptables.o to my application. I remember, that I've not done that
>>   because iptables never frees any memory - only allocates - not 
>>useful for a
>>   long time running program.
> 
> 
> this should be fixed now.

that would be nice, I think it's the easiest way for me

> 
> You have to consider a fourth option:
> 4) running iptables-restore --noflash and piping commands to stdin.


yes, I simply forgot this, will try this way, even if there are no more
memory leeks.
Can I use 1.2.7a or should I switch to 1.2.8?

> 
> Depending on your usage scenario (how frequent do you have ruleset
> changes?) this might be the fastest one.
It's for controlling internet access of pupil at a school.
I think every 1,5 h I have something about 100 changes in the tables.

Thank you
	Karsten
