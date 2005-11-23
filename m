From: Roberto Nibali <ratz@tac.ch>
Subject: Re: [PATCH 2.4] TCP window tracking: core implementation
Date: Wed, 23 Nov 2005 13:55:32 +0100
Message-ID: <438466C4.5040701@tac.ch>
References: <43819E72.5060704@tac.ch> <20051122165631.GA13716@alpha.home.local>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Willy Tarreau <willy@w.ods.org>
In-Reply-To: <20051122165631.GA13716@alpha.home.local>
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

Salut Willy,

>>A former version of this patch has been in production on a dozen nodes
>>for about 8 months now, and besides unmotivated DROPs invoked by
>>"non-RFC-comformant" applications, it works reasonably well.
>  
> Seconded !
> I've had it in production for 18 months now, handling between 1.2 and 1.8
> billions of sessions a month, and it still works like a charm.

Could you batch my patchset for your next -hf series, please? I'll try
to get you a tcpdump with erroneous behaviour regarding window tracking,
so you can verify this as well.

>>We'd hoped to overcome remaining "broken" applications by using the
>>NOTRACK flag to a filter rule. This would allow one to have a general
>>stateful packet filter with a few stateless rules for "broken"
>>applications; a feature most commercial firewall suites don't offer.
>>Unfortunately there is still an issue with regard to SMP and rmmod'ing
>>ip_conntrack while having NOTRACK rules loaded and network traffic
>>hitting NOTRACK and conntrack. Otherwise it works flawlessly. Patch will
>>follow shortly.
> 
> another possibility would be to add something like a "reason" code to the
> INVALID state, so that we could tell which types of invalids we still want
> to let go and which ones we definitely want to block.

This is of course possible but could potentially lead to a lot of
exception code. I reckon that it's safe enough to fallback to classic
packet filtering when dealing with non-RFC conform TCP clients or
applications. Meanwhile I've found the problem with the NOTRACK hanging
and will propose a fix in another thread I've started.

Best regards,
Roberto Nibali, ratz
-- 
-------------------------------------------------------------
addr://Kasinostrasse 30, CH-5001 Aarau tel://++41 62 823 9355
http://www.terreactive.com             fax://++41 62 823 9356
-------------------------------------------------------------
terreActive AG                       Wir sichern Ihren Erfolg
-------------------------------------------------------------
