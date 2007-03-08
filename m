From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Re: [PATCH] chaostables
Date: Thu, 8 Mar 2007 17:39:16 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0703081652310.2448@yvahk01.tjqt.qr>
References: <Pine.LNX.4.61.0703080723280.2448@yvahk01.tjqt.qr>
	<20070308131412.08d9973e@lxorguk.ukuu.org.uk>
	<Line.LNX.4.64.0703080955060.8029@d.namei>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
	Alan Cox <alan@lxorguk.ukuu.org.uk>, kaber@trash.net
To: James Morris <jmorris@namei.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Line.LNX.4.64.0703080955060.8029@d.namei>
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



(I suspect a mailserver issue on my side, since I did not receive the 
replies from Alan or Patrick. But lkml.org has them, so I will be 
replying to both them there.)

On Mar 8 2007 09:55, James Morris wrote:
>On Thu, 8 Mar 2007, Alan Cox wrote:
>
>> Any chance of tweaking the name - it's just there is/was a chaosnet 
>> protocol/network system and you don't want people to assume that 
>> since its a chaosfilter its for chaosnet ?
>
>That's exactly what I thought it was from the subject line.

Suggest something. (And then convince everyone who already set 
chaostables in stone to use the new name, namely search engines, 
bloggers, LWN, openwrt.) I don't think anyone seriously uses chaosnet 
nowadays. And just because there is a "quicktables" project does not 
mean there is a quick protocol filter.

Also note that the word 'chaostables' does not even appear in the patch, 
though xt_CHAOS does. Since we know that {xt,ipt}_[A-Z]+ are targets, we 
can safely assume that CHAOS does what it says - make fun of nmap.


>> Index: linux-2.6.21-rc3/net/netfilter/xt_CHAOS.c
>> ===================================================================
>> --- /dev/null
>> +++ linux-2.6.21-rc3/net/netfilter/xt_CHAOS.c
>> @@ -0,0 +1,184 @@
>> +
>> +static unsigned int xt_chaos_target(struct sk_buff **pskb,
>> +    const struct net_device *in, const struct net_device *out,
>> +    unsigned int hooknum, const struct xt_target *target, const void *targinfo)
>> +{
>> +	/* Equivalent to:
>> +	 * -A chaos -m statistic --mode random --probability \
>> +	 *         $reject_percentage -j REJECT --reject-with host-unreach;
>> +	 * -A chaos -m statistic --mode random --probability \
>> +	 *         $delude_percentage -j DELUDE;
>> +	 * -A chaos -j DROP;
>> +	 */
>
>What does this do that can't be done by simply adding those individual 
>rules?

It "wraps it all up", reducing the overall number of rules and user 
chains required in the filtering tables to implement the wanted logic. 
Reducing the number of filtering rules also reduces the time process a 
packet. These two are, in my opinion, a good thing.

Take xt_portscan as an example, which would require a minimum of 23 
filtering rules (which cannot reproduce the module's action in its 
fullest). 23 rules means we will be looping a bit in ipt_do_table() for 
a single packet, repeatedly checking for "-p tcp", i.e. calling into 
xt_tcpudp, checking for port ranges and perhaps other TCP fields that 
are never examined in xt_portscan.


>> Index: linux-2.6.21-rc3/net/netfilter/xt_DELUDE.c
>> ===================================================================
>> --- /dev/null
>> +++ linux-2.6.21-rc3/net/netfilter/xt_DELUDE.c
>
>Looks like a copy of the REJECT target. What does it do,
>why can't you use REJECT?

Looking only at TCP,
REJECT sends a RST for any packet (if requested), or ICMP otherwise.
DELUDE sends a SYN-ACK on SYN, otherwise RST.
(And TARPIT, for reference, keeps the connection open anytime. Its code
is also quite a replication of REJECT.)

If you think it is better to merge the respond-with-SYNACK into REJECT 
rather than having DELUDE, say so.


>> Index: linux-2.6.21-rc3/net/netfilter/xt_portscan.c
>> ===================================================================
>> --- /dev/null
>> +++ linux-2.6.21-rc3/net/netfilter/xt_portscan.c
>
>We already have the psd match for years, but decided against merging it.

On what basis? As far as I flew over psd's code, it uses a heuristic 
like "how often did that client recently connect" for match decision. 
(P2P clients randomly port knocking, anyone?) I would not think of that 
as a reliable way to tell portscans either. However, half-open TCP 
connect for example is a more clear action to define a portscan.



Jan
-- 
