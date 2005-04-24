From: Patrick McHardy <kaber@trash.net>
Subject: Re: --in-interface and --out-interface issue on bridge
Date: Sun, 24 Apr 2005 18:28:17 +0200
Message-ID: <426BC921.1080403@trash.net>
References: <20050421151458.03C6.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
In-Reply-To: <20050421151458.03C6.LARK@linux.net.cn>
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

Wang Jian wrote:
> Hi,
> 
> During my test, I find that --in-interface doesn't work as I expected.
> 
>   web server -- (eth0--br0--eth1)  -- web client
> 
> 
> # iptables -t mangle -A PREROUTING -i eth0 -p tcp --sport 80 \
> 	-j MARK --set-mark 1
> 
> doesn't set mark to 1.

Find out which interface is used using LOG. There is a physdev-match
for use with briding, perhaps this is what you need.

Regards
Patrick
