From: Pablo Neira <pablo@eurodev.net>
Subject: Re: nfnetlink-ctnetlink working: INSTRUCTIONS
Date: Thu, 14 Apr 2005 12:20:51 +0200
Message-ID: <425E4403.5010101@eurodev.net>
References: <20050414162843.032A.LARK@linux.net.cn>
	<425E3A7A.90905@eurodev.net>
	<20050414175616.0331.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, Amin Azez <azez@ufomechanic.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wang Jian <lark@linux.net.cn>
In-Reply-To: <20050414175616.0331.LARK@linux.net.cn>
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
>>Just eemove `inline' from ip_conntrack_free and ip_conntrack_insert. 
>>I've just fixed those in the patches, so alternatively you could 
>>download the patch again. This seems to be something gcc-3.4 related 
>>since I didn't get such error with gcc-2.95.
>>
> 
> 
> I remove the inline prefix from include/linux/netfilter_ipv4/ip_conntrack.h,
> and now it compiles.
> 
> But I think 
> 
> EXPORT_SYMBOL(ip_conntrack_insert);
> 
> is missing in net/ipv4/netfilter/ip_conntrack_standalone.c, isn't it?

Right, I've just fixed it, thanks.

--
Pablo
