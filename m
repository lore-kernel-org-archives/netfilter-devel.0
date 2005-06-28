From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 1/2] updates for [nf|ct]netlink and event API
Date: Tue, 28 Jun 2005 05:56:19 +0200
Message-ID: <42C0CA63.6080305@trash.net>
References: <42C03F2E.30706@eurodev.net> <42C07046.10101@trash.net>
	<42C0B2DF.8060907@eurodev.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@eurodev.net>
In-Reply-To: <42C0B2DF.8060907@eurodev.net>
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

Pablo Neira wrote:
> Patrick McHardy wrote:
>> This doesn't work reliably, locally generated packets never enter
>> PRE_ROUTING but can be DNATed. I think the hook should be supplied
>> by the user.
> 
> The macro HOOK2MANIP used is ip_nat_setup_info returns the same value
> (maniptype) for NF_IP_PRE_ROUTING and NF_IP_LOCAL_IN, so the same
> manipulation (DNAT) will be applied to such conntrack. Since we works
> with conntracks, I don't mind where the packets came from, just want to
> apply the NAT handling that the user has requested.

You're right, I'm still not familiar with the new NAT code ..

Regards
Patrick
