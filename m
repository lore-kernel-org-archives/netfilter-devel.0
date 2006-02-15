From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 0/3] nf_conntrack: fixes for nf_ct_attach in IPv6 stack
Date: Wed, 15 Feb 2006 10:01:44 +0100
Message-ID: <43F2EDF8.5030404@trash.net>
References: <43F0B76E.7050007@trash.net>
	<200602140348.k1E3msEc020481@toshiba.co.jp>
	<43F204B8.5060700@trash.net>
	<200602141759.k1EHxfk0009760@toshiba.co.jp>
	<43F21DBC.70506@trash.net>
	<Pine.LNX.4.58.0602142138090.23784@blackhole.kfki.hu>
	<20060215074740.GE15587@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, usagi-core@linux-ipv6.org,
	Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>,
	Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20060215074740.GE15587@sunbeam.de.gnumonks.org>
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

Harald Welte wrote:
> On Tue, Feb 14, 2006 at 09:41:59PM +0100, Jozsef Kadlecsik wrote:
> 
>>>RSTs and ICMP errors without existing connections should be ignored
>>>by conntrack (and marked as INVALID). Are you sure the RSTs create
>>>new conntracks?
>>
>>Marking packets created by the REJECT target as INVALID would break
>>the functionality of the target itself. Even if there is no real
>>"master" connection, RELATED was more appropriate.
> 
> 
> I totally agree.  Also, we have to keep 100% semantic compatibility with
> the existing ip_conntrack setups, otherwise we'd confuse users and
> create lots of broken packet filters.

Now I get it :) I assumed conntrack should recognize the ICMP or RST
as belonging to the original connection just as for forwarded packets,
but since it is not confirmed yet, this doesn't happen. So the patches
make perfect sense and I'm going to apply them now.
