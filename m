From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Sun, 04 Dec 2005 17:35:03 +0100
Message-ID: <43931AB7.8060400@trash.net>
References: <Pine.LNX.4.64.0511231128510.9162@bizon.gios.gov.pl>	<20051124200736.GW31478@sunbeam.de.gnumonks.org>	<20051124202125.GX31478@sunbeam.de.gnumonks.org>	<43864DC7.6060109@trash.net>	<Pine.LNX.4.64.0511250040030.14092@bizon.gios.gov.pl>	<20051125084427.GL31478@sunbeam.de.gnumonks.org>	<Pine.LNX.4.64.0511251019330.32144@bizon.gios.gov.pl>	<438710E1.2000202@trash.net>	<4387A946.3000005@eurodev.net>	<Pine.LNX.4.64.0511272313570.28434@bizon.gios.gov.pl>	<20051129040925.GC3544@rama.towersoft.de>	<438CDF45.9040308@trash.net>
	<4392630F.4040008@eurodev.net> <439313B2.50601@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira Ayuso <pablo@eurodev.net>
In-Reply-To: <439313B2.50601@trash.net>
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

Patrick McHardy wrote:
> Pablo Neira Ayuso wrote:
> 
>> Any update on this?
> 
> 
> I've added this patch to my queue. It doesn't even affect compatiblity,
> userspace can send both u_int8_t or u_int16_t, the binary representation
> will look the same.

After wakeing up entirely, I noticed this is nonsense, it depends on the
byte-order of course. Anyway, I'm going to push this patch forward
tonight, it seems libconntrack currently has a number of issues anyway.
