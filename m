From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: [HELP] what is the semantic meaning of find_appropriate_src()?
Date: Mon, 01 Mar 2004 17:13:49 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1078157629.669.59.camel@nienna.balabit>
References: <OF7E32BEEA.71DFB54B-ON48256E4A.0009FB21@legend.com.cn>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: wanghtb@legend.com.cn
In-Reply-To: <OF7E32BEEA.71DFB54B-ON48256E4A.0009FB21@legend.com.cn>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


  Hi,

On Mon, 2004-03-01 at 02:50, wanghtb@legend.com.cn wrote:
> I have studied the netfilter/iptables code for serval months, but I can 
> not understand the
> semantic meaning of function find_appropriate_src(), which is called by 
> get_unique_tuple().
> 
> I can not figure in what situation it can return TRUE( a proper manip) and 
>  I think even in the situation it can return TRUE, it is still 
> meaningless. I designed and tried some DNAT/SNAT examples, but none of 
> them can make find_appropriate_src() return TRUE.

  It's used to make sure that the same original source will be
translated to the same new address. When does it return TRUE? For
example when doing SNAT on UDP traffic, and one of your hosts on the
internal net sends packets from the same source port to distinct
destinations.

-- 
 Regards,
   Krisztian KOVACS
