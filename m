From: Wang Jian <lark@linux.net.cn>
Subject: Re: bidirectional CONNMARK?
Date: Wed, 09 Mar 2005 16:30:13 +0800
Message-ID: <20050309161949.A568.LARK@linux.net.cn>
References: <20050309124806.A55C.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050309124806.A55C.LARK@linux.net.cn>
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

Hi,

I have figured out how to do it with CONNMARK. Using --mask, I can
choose bits to use.

My iptables 1.2.9 doesn't give hint on mask for --set-mark, --save-mark
and --restore-mask. I just read the code from HEAD and realize.

I am happy. Thanks.

On Wed, 09 Mar 2005 13:26:19 +0800, Wang Jian <lark@linux.net.cn> wrote:

> Hi folks,
> 
> What is the CONNMARK's purpose? I think it is to reduce rule traversal,
> like this:
> 
> # iptables -A PREROUTING -t mangle \
>    -m connmark --mark 0xEF000000/0xFF000000 -j CONNMARK --restore-mark
> 
> # iptables -A PREROUTING -t mangle <matching rule 1-1> -j CONNMARK --set-mark 0xEF000001
> # iptables -A PREROUTING -t mangle <matching rule 1-2> -j CONNMARK --set-mark 0xEF000001
> # iptables -A PREROUTING -t mangle <matching rule 1-3> -j CONNMARK --set-mark 0xEF000001
> # iptables -A PREROUTING -t mangle <matching rule 2-1> -j CONNMARK --set-mark 0xEF000002
> # iptables -A PREROUTING -t mangle <matching rule 3-1> -j CONNMARK --set-mark 0xEF000003
> <snip a lot of rules>
> 
> But an issue occurs, when we want to set 2 different marks for a single
> session in two directions.
> 
> When doing QoS control as an router between two or more interfaces,
> bi-directional control is neccessary. Since nfmark is the most
> convenient way to classify packet, should we extend CONNMARK to support
> two marks?
> 
> Comment on this issue is welcome.
> 
> If it is a good idea, I will provide a patch for it.
> 
> 
> 
> 
> -- 
>   lark
> 



-- 
  lark
