From: Patrick McHardy <kaber@trash.net>
Subject: Re: CTA_PROTO_NUM u_int8_t or u_int16_t
Date: Tue, 22 Nov 2005 05:42:05 +0100
Message-ID: <4382A19D.9090201@trash.net>
References: <Pine.LNX.4.64.0511211534580.30476@bizon.gios.gov.pl>	<4381DF77.2030704@eurodev.net>
	<4381FDF8.6030508@trash.net> <43820874.2050708@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <43820874.2050708@eurodev.net>
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
> Patrick McHardy wrote:
> 
>>If you have to break compatibility, please do it before 2.6.15 is
>>released. But the easiest solution looks like keeping it a u_int16_t
>>and adjusting the NFA_PUT.
> 
> I think that I can fix it in nf_conntrack_netlink. ip_conntrack_netlink
> will go sooner or later.

I'm not sure that will be an avantage to breaking it immediately.
People should be able to use ctnetlink application with nfctnetlink,
so it will still break, but at that point the interface will already
be more established. We could just leave it a u_int16_t, but it won't
be in network byte order as the other attributes, which IMO needs to
be fixed if we ever want to use ctnetlink over the network without
adding lots of code in userspace just to fix up this single field.
