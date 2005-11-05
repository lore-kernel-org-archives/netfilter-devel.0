From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH 4/7] add missing module_alias_subsys
Date: Sat, 05 Nov 2005 08:31:08 +0100
Message-ID: <436C5FBC.70804@trash.net>
References: <436BA1C1.8070806@netfilter.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>,
	Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Pablo Neira <pablo@netfilter.org>
In-Reply-To: <436BA1C1.8070806@netfilter.org>
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
> Add missing module alias. This is a must to load ctnetlink on demand.
> For example, the conntrack tool will fail if the module isn't loaded.

I don't think this is a good idea currently. Capability checking is
done after module autoloading, so any user can load ctnetlink,
ip_conntrack and all related modules. Please make sure to move
capability checking in nfnetlink before module loading first.

BTW: The same applies to ip_tables and ipt_ULOG through netlink
autoloading.
