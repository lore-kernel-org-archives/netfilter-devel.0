From: Patrick McHardy <kaber@trash.net>
Subject: Re:  RFC: Disable defered bridge hooks by default
Date: Thu, 13 Jul 2006 16:38:05 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607131637550.15827@x2>
References: <W952101659891521152795405@hoboe1bl6.telenet-ops.be>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>,
	Philip Craig <philipc@snapgear.com>, Tom Eastep <teastep@shorewall.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "bdschuym@pandora.be" <bdschuym@telenet.be>
In-Reply-To: <W952101659891521152795405@hoboe1bl6.telenet-ops.be>
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

On Thu, 13 Jul 2006, bdschuym@pandora.be wrote:

>> Van: Patrick McHardy [mailto:kaber@trash.net]
>>
>> As I already mentioned in this thread, I believe the concept of calling
>> iptables from briding is flawed. We have ebtables to do filtering within
>> a bridge. But this is getting slightly off-topic.
>
> ebtables can't do things like stateful IP firewalling. IMO, things like
> transparent stateful firewalling are way too cool to just throw out of Linux
> because it troubles iptables somewhat in special cases.


Sure, I didn't suggest this. But the fact is that is doesn't work very
well together. Just using ip_conntrack (without NAT) without problems
should be relatively easy, its NAT and iptables that create problems.
Saying the problem cases are "special" (because they create problems)
does not help, users expect them to work because they way it presents
itself suggests they would work. But don't fear, I don't have any
further plans besides getting rid of the deferred hooks.
