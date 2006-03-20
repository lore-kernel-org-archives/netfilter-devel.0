From: Patrick McHardy <kaber@trash.net>
Subject: Re: New H.323 conntrack & NAT helper module
Date: Mon, 20 Mar 2006 15:22:57 +0100
Message-ID: <441EBAC1.8060007@trash.net>
References: <925A849792280C4E80C5461017A4B8A2032119@mail733.InfraSupportEtc.com><BAY109-DAV1E3EEAC01132FB3EE2E2EB3F00@phx.gbl><44001CDD.3030305@trash.net><BAY109-DAV1A4C43C331B9AEBC1F22EB3F00@phx.gbl><4400A541.9080901@trash.net><BAY109-DAV96ADAFAB4170550F4A52FB3F40@phx.gbl><440960E4.80601@trash.net><BAY109-DAV1330DD37E6D3BA0FF46E0DB3E00@phx.gbl><44158920.30700@trash.net><BAY109-DAV757C3488B317953CCA29AB3E70@phx.gbl>
	<4419281D.6050702@trash.net>
	<BAY109-DAV69864489FACDF598B1718B3E50@phx.gbl>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jing Min Zhao <zhaojingmin@hotmail.com>
In-Reply-To: <BAY109-DAV69864489FACDF598B1718B3E50@phx.gbl>
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

Jing Min Zhao wrote:
> The main new feature of this release is T.120 support. So chat, whiteboard,
> file transfer and other T.120 applications are now supported.
> 
> Signed-off-by: Jing Min Zhao <zhaojignmin@hotmail.com>

Thanks, applied. I've made three small changes before applying it:

- Change gkrouted_only default to 1
- Remove #ifndef offsetof in ASN.1 parser
- Initialize datalen to 0 in ras_help to silence an incorrect gcc
  warning. I usually don't do this, but last time Linus complained
  about new code giving (a correct) warning.

Thanks again.
