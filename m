From: Patrick McHardy <kaber@trash.net>
Subject: Re: connbytes & 64bit counters
Date: Sat, 21 Jul 2007 06:18:46 +0200
Message-ID: <46A18926.6040402@trash.net>
References: <Pine.LNX.4.64.0610250035100.23937@bizon.gios.gov.pl>
	<453FE325.1040502@trash.net>
	<Pine.LNX.4.64.0610281716090.19053@bizon.gios.gov.pl>
	<45462043.5010207@trash.net>
	<Pine.LNX.4.64.0610302055060.3941@bizon.gios.gov.pl>
	<4565AAC7.8050702@trash.net> <45660CD5.1090405@netfilter.org>
	<4566B6B6.4060808@trash.net>
	<Pine.LNX.4.64.0612250252060.27316@bizon.gios.gov.pl>
	<45A4EBC8.60304@trash.net>
	<Pine.LNX.4.64.0701151141410.13986@bizon.gios.gov.pl>
	<45AB919A.4030100@trash.net>
	<Pine.LNX.4.64.0707202350290.4877@bizon.gios.gov.pl>
	<Pine.LNX.4.64.0707210038370.7261@bizon.gios.gov.pl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, netfilter-devel@lists.netfilter.org,
	Krzysztof Oledzki <olenf@ans.pl>, Pablo Neira Ayuso <pablo@netfilter.org>
To: Krzysztof Oledzki <ole@ans.pl>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <Pine.LNX.4.64.0707210038370.7261@bizon.gios.gov.pl>
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

Krzysztof Oledzki wrote:
> Errr, incomplete patch, sorry... This one should work.
> 
> [NETFILTER]: Reimplementation of 64bit counters for bytes/packets
> accounting


I thought about this today, but came to no conclusion. We have ct_extend
now, allowing to allocate the counters dynamically for new conntracks,
and the only reasonable thing IMO (considering distributors that waste
16 bytes per conntrack for a feature pratically *nobody* uses, with your
patch that actually fixes a regression 32 byte) would be to make
accounting optional and triggered by a target in the raw table. Its so
far used by default and the counters are visible through /proc and
ctnetlink though. So this would break compatibility. OTOH I think its
totally ridiculous to waste this much memory for something pratically
nobody uses. So my current opinion is between just breaking
compatibility (with some grace period perhaps) and trying to behave
half-way compatible when ctnetlink is loaded. I don't think the second
option will work though. And frankly, the current code it totally
broken, it will send a COUNTER_OVERFLOW event *for each packet* when
the counters exceed 2^31. So its really questionable if anyone actually
uses this, without further patches.

Opinions are welcome.
