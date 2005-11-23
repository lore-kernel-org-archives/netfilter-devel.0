From: Pablo Neira <pablo@eurodev.net>
Subject: Re: [PATCH] CTA_PROTO_NUM is u_int8_t not u_int16_t (was
 Re:	CTA_PROTO_NUM u_int8_t or u_int16_t)
Date: Wed, 23 Nov 2005 02:15:53 +0100
Message-ID: <4383C2C9.8050109@eurodev.net>
References: <Pine.LNX.4.64.0511211534580.30476@bizon.gios.gov.pl>	<4381DF77.2030704@eurodev.net>
	<4381FDF8.6030508@trash.net>	<43820874.2050708@eurodev.net>
	<4382A19D.9090201@trash.net>	<43836BAF.2050501@eurodev.net>	<Pine.LNX.4.64.0511222103050.9114@bizon.gios.gov.pl>
	<20051122220606.GC31478@sunbeam.de.gnumonks.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
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
> On Tue, Nov 22, 2005 at 09:29:51PM +0100, Krzysztof Oledzki wrote:
> 
>>On Tue, 22 Nov 2005, Pablo Neira wrote:
>>
>>
>>>Patrick McHardy wrote:
>>>
>>>>Pablo Neira wrote:
>>>>
>>>>>Patrick McHardy wrote:
>>>>>
>>>>>>If you have to break compatibility, please do it before 2.6.15 is
>>>>>>released. But the easiest solution looks like keeping it a u_int16_t
>>>>>>and adjusting the NFA_PUT.
>>>>>
>>>>>I think that I can fix it in nf_conntrack_netlink. ip_conntrack_netlink
>>>>>will go sooner or later.
>>>>
>>>>I'm not sure that will be an avantage to breaking it immediately.
>>>>People should be able to use ctnetlink application with nfctnetlink,
>>>>so it will still break, but at that point the interface will already
>>>>be more established. We could just leave it a u_int16_t, but it won't
>>>>be in network byte order as the other attributes, which IMO needs to
>>>>be fixed if we ever want to use ctnetlink over the network without
>>>>adding lots of code in userspace just to fix up this single field.
>>>
>>>Better to fix it, break backward compatibility now and forget about this
>>>issue.
>>
>>Isn't it possible to add kernel version checking into libnetfilter_conntrack and send 
>>CTA_PROTO_NUM as u_int16_t under 2.6.14 and as u_int8_t under 2.6.15+? The protonum is 
>>alredy defined as u_int8_t in struct nfct_tuple (libnetfilter_conntrack.h).
> 
> 
> It can be fixed without any compatibility issues, at least in one
> direction.
> 
> If the new kernel accepts both a 8 bit and 16bit value, then new
> userspace programs (who send 8bit) and old userspace programs would run
> on new kernels.  only for old kernels you need the old app.
> 
> another alternative was to introduce a new CTA_PROTO_NUM8 value, which
> is more explicit (but somehow stupid).

Why don't we send a patch to -stable? I think that most people will use
lastest stable branch in 2.6.14, so only < 2.6.14.3 would be broken. I
still don't like too much the idea of adding a new field just because of
this bugfix :(

-- 
Pablo
