From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH] netfilter: masquerade: don't flush all conntracks if
 only one address deleted on device
Date: Fri, 28 Sep 2018 14:22:11 +0200
Message-ID: <20180928122211.vxjfcrme6oiukjol@salvia>
References: <1536309213-19632-1-git-send-email-tan.hu@zte.com.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: kadlec@blackhole.kfki.hu, fw@strlen.de, davem@davemloft.net,
        kuznet@ms2.inr.ac.ru, yoshfuji@linux-ipv6.org,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        zhong.weidong@zte.com.cn, jiang.biao2@zte.com.cn
To: Tan Hu <tan.hu@zte.com.cn>
Return-path: <linux-kernel-owner@vger.kernel.org>
Content-Disposition: inline
In-Reply-To: <1536309213-19632-1-git-send-email-tan.hu@zte.com.cn>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Fri, Sep 07, 2018 at 04:33:33PM +0800, Tan Hu wrote:
> We configured iptables as below, which only allowed incoming data on
> established connections:
> 
> iptables -t mangle -A PREROUTING -m state --state ESTABLISHED -j ACCEPT
> iptables -t mangle -P PREROUTING DROP
> 
> When deleting a secondary address, current masquerade implements would
> flush all conntracks on this device. All the established connections on
> primary address also be deleted, then subsequent incoming data on the
> connections would be dropped wrongly because it was identified as NEW
> connection.
> 
> So when an address was delete, it should only flush connections related
> with the address.

Applied to nf-next, thanks.
