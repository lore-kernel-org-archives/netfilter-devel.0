From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: MARK targets all non-terminating
Date: Sun, 7 Jan 2007 03:09:37 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0701070254230.27682@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0701021838580.4001@yvahk01.tjqt.qr>
	<459AA3B2.4010008@shorewall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	kaber@trash.net
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <459AA3B2.4010008@shorewall.net>
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


On Jan 2 2007 10:25, Tom Eastep wrote:
>> 
>> This non-terminating behavior of [file list] is _NOT_ documented in the 
>> iptables manpage. Is it even intended at all?
>
>A couple of observations:
>
>a) This non-terminating behavior has been around since the MARK targets first
>   appeared so existing tools and scripts depend on it. As an example, if
>   "-j MARK" were suddenly terminating, most current uses of
>   "-j CONNMARK --save-mark" would cease working since they typically
>   follow matching "-j MARK" rules.
>   
>c) ebtables provides a nice solution which allows "-j mark" to be either
>   terminating (the default), or non-terminating depending on the
>   inclusion of a "--mark-target" phrase. That would be a nice addition
>   to the iptables MARK targets, so long as the default was CONTINUE
>   rather than ACCEPT.

I was about to extend the kernel and iptables to support something along the
lines of

  iptables -t mangle -A POSTROUTING -j MARK --mark 117 --terminate

but then faced the problem of what verdict to return in xt_MARK when
--terminate is given. NF_DROP? No, that could possibly interfere
with the default chain policy. Same goes for NF_ACCEPT. NF_STOLEN,
NF_QUEUE and NF_STOP do not seem to be the right ones either. We'd
need some sort of NF_EXIT in ipt_do_table, which essentially jumps
right out of all user-defined chains to the end of the table to hit
the default policy. ip_tables.c already is quite strech-intended (5
and more, according to CodingStyle, you're bust) and adding more code
would make it worse.

What is the right approach (as in "DTRT") the nf developers can
suggest to implement a target terminating like this?


Thanks,
Jan
-- 
