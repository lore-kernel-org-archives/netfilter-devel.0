From: Patrick McHardy <kaber@trash.net>
Subject: Re: ipsec patches test: minor compilation and policy match issues
Date: Wed, 28 Apr 2004 02:30:12 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <408EFB14.3040906@trash.net>
References: <20040415212034.GE7611@obs.bg> <407FE99D.6010100@trash.net>  <20040424101748.GB23401@obs.bg> <19797.1083092339@marajade.sandelman.ottawa.on.ca>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Michael Richardson <mcr@sandelman.ottawa.on.ca>
In-Reply-To: <19797.1083092339@marajade.sandelman.ottawa.on.ca>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Michael Richardson wrote:
>>>>>>"Ivan" == Ivan Mitev <imitev@obs.bg> writes:
> 
>     Ivan> i tried to use the ipsec policy for a transport mode, AH+ESP,
>     Ivan> but i don't manage to get it working (ie pkts are not matched
>     Ivan> by the ipsec policy rule) however AH or ESP alone work fine.
> 
>     Ivan> btw, maybe no one uses AH + ESP, but that's only a test...
> 
>   There is really no point in mixing them.
>   ESP in RFC2401 IPsec (vs 1827) provides authentication.

You're right, especially no one uses AH tunnel + ESP tunnel,
but Linux supports it, so testing these cases is at least at
important as testing the common cases, because bugs in
common setups are likely to show up soon.

Regards
Patrick
