From: Patrick McHardy <kaber@trash.net>
Subject: Re: RFC: Disable defered bridge hooks by default
Date: Thu, 13 Jul 2006 09:35:48 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0607130933380.15827@x2>
References: <44AA3446.6050609@trash.net> <44AA3496.5050909@trash.net>
	<44AEFE20.3020307@shorewall.net> <44AF200F.9000204@trash.net>
	<44B40B4E.6080206@shorewall.net> <44B4183E.7010905@trash.net>
	<44B57A9F.9000403@shorewall.net>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>,
	Bart De Schuymer <bdschuym@pandora.be>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Tom Eastep <teastep@shorewall.net>
In-Reply-To: <44B57A9F.9000403@shorewall.net>
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

On Wed, 12 Jul 2006, Tom Eastep wrote:

> Patrick McHardy wrote:
>>
>>> So that I understand the playing field, --physdev-out will no longer be
>>> supported out of the FORWARD and OUTPUT chains (all tables); is that correct?
>>
>> For locally generated traffic (-o br0), yes. This feature is going to
>> be removed, but I think it might be more useful to gather some data
>> among your users who actually needs this. I did some google-research
>> myself, and I wasn't able to find more then a handful of examples
>> of people actually using it this way. I certainly would be interested
>> in this data, if it really is needed by a significant larger amount
>> than I thought I will consider migation strategies stronger than
>> before. So far I'm not convinced that this really will pose a problem.
>
> I copied you privately on the survey that I sent out to Shorewall users -- so
> far, two out of four responders filter traffic from the firewall to the bridge
> based on egress port and three out of four filter outbound bridge traffic routed
> from an unbridged interface based on egress port.


Thanks. I'm currently travelling, I'll look at this on Sunday when I get
back home (haven't received it yet I think). Do you know on which criteria
they filter in addition to the bridge port?
