From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was
 Re:	CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Wed, 23 Nov 2005 10:47:58 +0100
Message-ID: <43843ACE.4050808@trash.net>
References: <Pine.LNX.4.64.0511211534580.30476@bizon.gios.gov.pl>	<4381DF77.2030704@eurodev.net>
	<4381FDF8.6030508@trash.net>	<43820874.2050708@eurodev.net>
	<4382A19D.9090201@trash.net>	<43836BAF.2050501@eurodev.net>	<Pine.LNX.4.64.0511222103050.9114@bizon.gios.gov.pl>
	<20051122220606.GC31478@sunbeam.de.gnumonks.org>
	<4383C2C9.8050109@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <4383C2C9.8050109@eurodev.net>
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

Pablo Neira wrote:
> Harald Welte wrote:
> 
>>another alternative was to introduce a new CTA_PROTO_NUM8 value, which
>>is more explicit (but somehow stupid).
> 
> 
> Why don't we send a patch to -stable? I think that most people will use
> lastest stable branch in 2.6.14, so only < 2.6.14.3 would be broken. I
> still don't like too much the idea of adding a new field just because of
> this bugfix :(

I would be fine with this.
