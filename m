From: Pablo Neira Ayuso <pablo@netfilter.org>
Subject: Re: [PATCH 10/10][CONNTRACK] introduce the pickup flag to take over
 connections
Date: Thu, 13 Jul 2006 22:22:01 +0200
Message-ID: <44B6AB69.7030700@netfilter.org>
References: <44ADC415.5030407@netfilter.org>
	<Pine.LNX.4.58.0607091718580.11722@blackhole.kfki.hu>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Patrick McHardy <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>
In-Reply-To: <Pine.LNX.4.58.0607091718580.11722@blackhole.kfki.hu>
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

Jozsef Kadlecsik wrote:
> Hi Pablo,
> 
> On Fri, 7 Jul 2006, Pablo Neira Ayuso wrote:
> 
> 
>>This patch introduces a new flag called IPS_PICKUP that forces the
>>protocol handler to pick up the required information in order to ensure
>>that the connection will reach a successful state. Currently, the only
>>client is the TCP protocol helper.
>>
>>More arguments conntrackd or whatever failover solution need this.
>>
>>@Jozsef: You know better TCP sequence tracking in-deep details, can you
>>see any problem with this?
> 
> Nothing against it as I see. But I'd regard it as a preliminary step
> toward creating conntrack entries by conntrackd/failover: the missing bits
> are the flags (SACK and WSCALE) and the window scale factor. We assume
> SACK is on (which thus don't hurt), but disabled window scaling can really
> bite if it's actually on.

Interesting, since the scale factor is only advertised in the SYN+ACK 
packet, we need a patch to introduce a new ctnetlink attribute that 
contains the scale factor. I think that should be enough.

Thanks for the clue.

-- 
The dawn of the fourth age of Linux firewalling is coming; a time of 
great struggle and heroic deeds -- J.Kadlecsik got inspired by J.Morris
