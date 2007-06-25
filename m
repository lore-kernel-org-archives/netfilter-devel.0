From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC][PATCH 0/10]: ct_extend
Date: Mon, 25 Jun 2007 12:16:35 +0200
Message-ID: <467F9603.2070005@trash.net>
References: <200706250314.l5P3E2M4008231@toshiba.co.jp>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: rusty@rustcorp.com.au, netfilter-devel@lists.netfilter.org,
	pablo@netfilter.org, kadlec@blackhole.kfki.hu
To: Yasuyuki KOZAKAI <yasuyuki.kozakai@toshiba.co.jp>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <200706250314.l5P3E2M4008231@toshiba.co.jp>
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

Yasuyuki KOZAKAI wrote:
> Hi,
> 
> This patch set is a snapshot of the ct_extend, which shrinks memory
> usage where extensions such as NAT and helper are not used.
> 
> I've applied all suggestions from Patrick. If nat module is loaded,
> ct_extend pre-allocates extended area of NAT when it initially allocates
> extended area of helper. I've also renamed functions to nf_ct_ext_* and
> merged the members in 'struct nf_nat_info' into 'struct nf_conn_nat'.


The patches look pretty good to me. For normal conntracks without
NAT or helpers its a clear win since we avoid the double search of
expectations. The only case I'm a bit worried about is NAT, for that
case we get an extra allocation for every new connection. But I
guess thats better than what we have now, the double search reportedly
costs about 10% performance for all cases.

Do you think we should put these patches in 2.6.23?
