From: Jordan Russell <jr-list-2007@quo.to>
Subject: Re: ICMP packets associated with NAT connections sent out wrong
	interface?
Date: Thu, 05 Jul 2007 12:05:21 -0500
Message-ID: <468D24D1.1040005@quo.to>
References: <468C15EE.9060806@quo.to>	<200707050111.l651Bu9t008798@toshiba.co.jp>	<468C86C9.7050204@quo.to>
	<200707051117.l65BHBA6013655@toshiba.co.jp>
	<468CE260.2040500@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, netfilter@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <468CE260.2040500@trash.net>
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

Patrick McHardy wrote:
> Its pretty certain the REJECT target, it defauls to port unreachable
> and the network stack doesn't generate port unreachables for TCP.
> Jordan, please post your ruleset.

Yes, I have a REJECT rule for non-ESTABLISHED incoming packets on eth1.
Please see this post for rules sufficient to reproducing the issue:

http://lists.netfilter.org/pipermail/netfilter/2007-July/069182.html

>>>  0000:01:0c.0: scatter/gather disabled. h/w checksums disabled
>
>
> I can't find this message in the kernel tree. Which driver are you
> using?

It's 3c59x.

-- 
Jordan Russell
