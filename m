From: Patrick McHardy <kaber@trash.net>
Subject: Re: hashlimit not working in iptable chains
Date: Fri, 01 Dec 2006 17:27:32 +0100
Message-ID: <457057F4.3050703@trash.net>
References: <b322db070612010336v62e5f822pf9b6e1397b22b859@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-request@lists.netfilter.org, netfilter-devel@lists.netfilter.org,
	netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Retesh <retesh.chadha@gmail.com>
In-Reply-To: <b322db070612010336v62e5f822pf9b6e1397b22b859@mail.gmail.com>
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

Retesh wrote:
> Hi All
> I am having a scenario where the iptables hashlimit feature is not
> working as expected. Following is the list of IP rules
> 
> INPUT (policy ACCEPT 1342 packets, 488K bytes)
> 1840  755K TEST       all  --  any    any     anywhere             anywhere
> 
> TEST (1 references)
> 0     0 CHAIN2     all  --  any    any     anywhere
> anywhere            set SET2 dst
> 1840  755K CHAIN1     all  --  any    any     anywhere
> anywhere            set SET1 dst
> 
> CHAIN1 (1 references)
> 919  375K ACCEPT     all  --  any    any     anywhere
> anywhere            limit: avg 200/sec burst 10 mode dstip
> 921  380K LOG        all  --  any    any     anywhere
> anywhere            LOG level warning prefix `_SET1'
> 
> CHAIN2 (1 references)
> 0     0 ACCEPT     all  --  any    any     anywhere
> anywhere            limit: avg 50/sec burst 10 mode dstip
> 0     0 LOG        all  --  any    any     anywhere
> anywhere            LOG level warning prefix `_SET2'
> 
> Here, SET1 and SET2 are iphash
> 
> Now after applying the above rules, irrespective of which set (SET1 or
> SET2), I send the packets from I find that the limit that is used is
> 50/s, even though there are different chains for different sets. That
> is packets from SET1  match CHAIN1 but the hashlimit value thats used
> is 50/s.
> So effectively the hashlimit that is set for all the chains is the one
> in the chain that occurs first.
> 
> Am I doing something wrong here, or is this a limitation with hashlimit?


This is a know problem, the limit is a property of the hashlimit table,
not the individual rules. You have to use seperate --hashlimit-name
parameters.
