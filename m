From: Patrick McHardy <kaber@trash.net>
Subject: Re: Fw: Re: 2.6.14-rc1 Critical bug: machine complete freeze
Date: Sun, 18 Sep 2005 17:03:55 +0200
Message-ID: <432D81DB.5010106@trash.net>
References: <20050917133943.30983afd.akpm@osdl.org> <432C8178.40201@trash.net>
	<432C8398.9060202@gmail.com> <432C8590.9070600@trash.net>
	<432D15BC.3070500@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: patrizio.bassi@gmail.com
In-Reply-To: <432D15BC.3070500@gmail.com>
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

[moved to netfilter-devel]

Patrizio Bassi wrote:
> Patrick McHardy ha scritto:
>> Please try if turning it off helps. The deadlock is pretty likely to
>> happen in other situations too, its best not to use event notifications
>> currently.
>>
> yes, i tested and it works now.
> as trivial and fast fix you can block both by config script.

Just turning off event notifications should be fine .. I want people
to use the netbios helper.

> i have some big problems with forwarding and bridge configuration too.
> i've been investigating to find the real problem, in order to report a
> valid bug-entry.
> 
> in few words:
> iptables works perfectly, apart for icmp forwarding.
> it's not a iptables wrong config, because if i destroy the chains and i
> reload them it works perfectly.
> 
> test situation:
> 
> Client -> Router with bridge
> 
> I start the Router, apply iptables rules, connect to internet, perfect.
> I start the Client, try to ping the router or google, nothing.
> Destroy iptables, reload rules in the Router.
> Client can ping google and router.
> 
> My iptables script was about 1 year old, and worked perfectly.
> New kernel (dunno which...2.6.1x) introduced this problem.

Try adding some logging rules to see why it gets dropped (-m state
--state INVALID for example).
