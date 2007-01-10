From: Patrick McHardy <kaber@trash.net>
Subject: Re: xt_MARK useless line
Date: Wed, 10 Jan 2007 16:42:35 +0100
Message-ID: <45A5096B.40509@trash.net>
References: <Pine.LNX.4.61.0612291752440.9799@yvahk01.tjqt.qr>
	<20070107141557.GB13543@prithivi.gnumonks.org>
	<Pine.LNX.4.61.0701071613520.4365@yvahk01.tjqt.qr>
	<45A18EE8.5080909@snapgear.com> <45A47F66.2050603@trash.net>
	<Pine.LNX.4.61.0701101205010.3029@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>,
	Philip Craig <philipc@snapgear.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jan Engelhardt <jengelh@linux01.gwdg.de>
In-Reply-To: <Pine.LNX.4.61.0701101205010.3029@yvahk01.tjqt.qr>
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

Jan Engelhardt wrote:
> On Jan 10 2007 06:53, Patrick McHardy wrote:
> 
>>I vote for removing this (also in CONNMARK, CONNSECMARK, ...).
>>
> 
> 
> Not everywhere, xt_CONNMARK has a place where:
> 
> newmark = (*ctmark & ~markinfo->mask) | markinfo->mark;
> if (newmark != *ctmark) {
>     *ctmark = newmark;
> #if defined(CONFIG_IP_NF_CONNTRACK) || defined(CONFIG_IP_NF_CONNTRACK_MODULE)
>     ip_conntrack_event_cache(IPCT_MARK, *pskb);
> #else
>     nf_conntrack_event_cache(IPCT_MARK, *pskb);
> #endif
> }
> 
> Would it matter to call these cache functions it even if the mark did
> not really change?

Yes.

> 
> ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
> 
> Remove unnecessary if() constructs before assignment.
> Plus one spelling fix, one brace indent fix.

Queued for 2.6.21 (without the spelling fix since that touched
a totally unrelated file), thanks.
