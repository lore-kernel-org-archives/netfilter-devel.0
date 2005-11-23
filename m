From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was Re:
 CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Wed, 23 Nov 2005 02:06:35 +0100
Message-ID: <4383C09B.7000200@trash.net>
References: <Pine.LNX.4.64.0511211534580.30476@bizon.gios.gov.pl>
	<4381DF77.2030704@eurodev.net> <4381FDF8.6030508@trash.net>
	<43820874.2050708@eurodev.net> <4382A19D.9090201@trash.net>
	<43836BAF.2050501@eurodev.net>
	<Pine.LNX.4.64.0511222103050.9114@bizon.gios.gov.pl>
	<20051122220606.GC31478@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Harald Welte <laforge@netfilter.org>
In-Reply-To: <20051122220606.GC31478@sunbeam.de.gnumonks.org>
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
> It can be fixed without any compatibility issues, at least in one
> direction.
> 
> If the new kernel accepts both a 8 bit and 16bit value, then new
> userspace programs (who send 8bit) and old userspace programs would run
> on new kernels.  only for old kernels you need the old app.
 >
> another alternative was to introduce a new CTA_PROTO_NUM8 value, which
> is more explicit (but somehow stupid).

Lets do that and call it CTA_PROTO, I don't like the _NUM anyway :)
