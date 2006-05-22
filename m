From: Patrick McHardy <kaber@trash.net>
Subject: Re: [Xen-devel] Re: Panic in ipt_do_table with 2.6.16.13-xen
Date: Mon, 22 May 2006 16:43:37 +0200
Message-ID: <4471CE19.5070802@trash.net>
References: <4468BE70.7030802@tektonic.net>
	<4468D613.20309@trash.net>	<44691669.4080903@tektonic.net>	<Pine.LNX.4.64.0605152331140.10964@d.namei>	<4469D84F.8080709@tektonic.net>	<Pine.LNX.4.64.0605161127030.16379@d.namei>	<446D0A0D.5090608@tektonic.net>	<Pine.LNX.4.64.0605182002330.6528@d.namei>
	<446D0E6D.2080600@tektonic.net> <446D151D.6030307@tektonic.net>
	<4470A6CD.5010501@trash.net> <4471CB54.401@tektonic.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Matt Ayres <matta@tektonic.net>
In-Reply-To: <4471CB54.401@tektonic.net>
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

Matt Ayres wrote:
> 
> 
> Patrick McHardy wrote:
> 
>> Matt Ayres wrote:
>>
>>> I think I confirmed the NIC is not the source of the problem.  A few of
>>> my servers have e100/tulip NIC's due to a bug with the chipset of the
>>> on-board TG3 cards firmware and TSO.  These servers that use the
>>> e100/tulip drivers also experience the ipt_do_table bug.
>>
>>
>> There is an identical report in the netfilter bugzilla, also crashes
>> (on x86_64) in ipt_do_table with Xen. I haven't heard anything of
>> similar crashes without Xen, so I doubt that the bug is in the
>> netfilter code.
>>
>> https://bugzilla.netfilter.org/bugzilla/show_bug.cgi?id=478
> 
> 
> Yep... too coincidental.  I'd say it has _something_ to do with Xen.
> I've been doing different things on my side to try to reduce the
> severity of the problem, but I'd really like to hear what the Xen guys
> have to say about this now..


Maybe this helps: there is not too much the Xen code could be doing
wrong here. If I read your crash correctly it happend in the FORWARD
chain, which could mean that the outgoing device (probably the Xen
virtual network driver) has some bugs, but iptables really only cares
about the names at this point, which practically can't be bogus.
The only other thing I can imagine is that something is wrong with
the per-CPU copy of the ruleset, i.e. either smp_processor_id is
returning garbage or for_each_possible_cpu misses a CPU during
initialization. I have no idea if Xen really does touch this code,
but other than that I don't really see what it could break.
