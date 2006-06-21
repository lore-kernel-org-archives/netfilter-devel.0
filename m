From: Philip Craig <philipc@snapgear.com>
Subject: Re: [RFC][1/2] New netfilter match module : kernel patch
Date: Wed, 21 Jun 2006 10:42:20 +1000
Message-ID: <449895EC.5060603@snapgear.com>
References: <20060602190238.92524.qmail@web50208.mail.yahoo.com>
	<4496C505.9080907@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: Alex Davis <alex14641@yahoo.com>, netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <4496C505.9080907@trash.net>
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

On 06/20/2006 01:38 AM, Patrick McHardy wrote:
> Alex Davis wrote:
>> This is an update the kernel netfilter patch that allows 
>> matching the source or destination address of an IP
>> packet to a network interface.
> 
> I can't see any other way to do this, but I'm not so thrilled to
> add a whole new match just for this.

My current solution for this is to reinstall the iptables
rules from the dhcp client script hooks, or from the ppp
ip-up script.

Another option that doesn't require reinstalling rules would
be to use an ipset in the rule, and then use the scripts to
update the address in the ipset.
