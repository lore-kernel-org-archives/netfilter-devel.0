From: Bart De Schuymer <bdschuym@pandora.be>
Subject: Re: ipq+AF8-set+AF8-verdict problem in bridge+-iptables
Date: Thu, 17 Jul 2003 08:01:03 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <200307170801.04051.bdschuym@pandora.be>
References: <003e01c34c0d$ca8c3d20$8101a8c0@dev>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="utf-7"
Content-Transfer-Encoding: 7bit
Cc: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "Yong" <sdssly@sina.com>, "Harald Welte" <laforge@netfilter.org>
In-Reply-To: <003e01c34c0d$ca8c3d20$8101a8c0@dev>
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Thursday 17 July 2003 04:47, Yong wrote:
> I am using the bridge-nf-0.0.7-against-2.4.19.diff patch. I cannot find the
> skb->nf_bridge member. It seems that I need to use another patch. Is it
> true? Can I add the bridge-nf-0.0.10-against-2.4.20.diff patch directly on
> my Linux 2.4.20?

I'd use 2.4.21 with the 2.4-ebtables-brnf patch, see 
http://sourceforge.net/projects/ebtables/


cheers,
Bart
