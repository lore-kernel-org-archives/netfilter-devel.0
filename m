From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] update quota match for xtables + fix -D bug
Date: Tue, 08 Aug 2006 11:33:32 +0200
Message-ID: <44D85A6C.9060402@trash.net>
References: <20060802024322.GA15127@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20060802024322.GA15127@linuxace.com>
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

Phil Oester wrote:
> The iptables quota match has not been updated to reflect the new xtables
> location/structures in 2.6.18-rc.  In addition, it has a bug which makes
> it impossible to delete a rule once added.  E.g.:
> 
> # iptables -A foo -m quota --quota 1111 -j RETURN
> # iptables -D foo -m quota --quota 1111 -j RETURN
> iptables: Bad rule (does a matching rule exist in that chain?)
> 
> Below patch fixes both issues and resolve bugzilla #496.

Also applied, thanks.
