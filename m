From: KOVACS Krisztian <hidden@balabit.hu>
Subject: Re: 2.4.25 crash with conntrack msgs in the kernel log
Date: Thu, 04 Mar 2004 13:22:18 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1078402938.773.38.camel@nienna.balabit>
References: <1078250798.957.58.camel@vijay>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Vijaya Chandra Vupputuri <vijay@tachyontech.net>
In-Reply-To: <1078250798.957.58.camel@vijay>
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

On Tue, 2004-03-02 at 19:08, Vijaya Chandra Vupputuri wrote:
> The system acts as the gateway for around 500 active users, with around
> 1000 rules in the forward chain and around 400 chains, each of these
> chains with one rule (using the 'ipt_quota' match), in the filter table
> and around 1500 rules in the 'nat' table, HTB, being the one used for
> shaping bandwidth.

  What conntrack/NAT helpers do you use? Which modules are loaded in the
kernel?

-- 
 Regards,
   Krisztian KOVACS
