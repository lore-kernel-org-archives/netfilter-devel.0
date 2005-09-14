From: Nuutti Kotivuori <naked@iki.fi>
Subject: Re: netfilter QUEUE target and packet socket interactions buggy or
	not
Date: Wed, 14 Sep 2005 11:31:17 +0300
Message-ID: <87y86082zu.fsf@aka.i.naked.iki.fi>
References: <87fysa9bqt.fsf@aka.i.naked.iki.fi>
	<20050912.151120.104514011.davem@davemloft.net>
	<87br2xap9o.fsf@aka.i.naked.iki.fi>
	<877jdl9r1u.fsf@aka.i.naked.iki.fi> <4326FF69.9060004@trash.net>
	<873bo8akvk.fsf@aka.i.naked.iki.fi> <43279058.1080200@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <43279058.1080200@trash.net> (Patrick McHardy's message of "Wed,
	14 Sep 2005 04:52:08 +0200")
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
> Nuutti Kotivuori wrote:
>> Patrick McHardy wrote:
>>
>>> What kind of packet is this? And what kernel version are you
>>> running? Until recently ip_conntrack did some fiddling with skb->sk
>>> which could lead to a packet on the output path with skb->sk set but
>>> no reference taken.
>>
>> This happens on Red Hat Enterprise Linux 4, with a 2.6.9 kernel (with
>> a gazillion of Red Hat patches in it, latest ones being from 2.6.11)
>> and the ip_queue patch that adds the bottom-half disabling. I will
>> know for sure tomorrow, but it seems that it doesn't appear on vanilla
>> 2.6.13.1 or without SMP.
>
> Hmm .. I don't want to spend time fixing bugs already fixed, so it
> would be good if you could confirm that the bug still exists in the
> current vanilla kernel.

The bug does *not* appear on vanilla 2.6.13.1. The test isn't 100%
conclusive, as the kernel configs differ a bit and I had to disable
selinux policy at boot since there were some differences in the
generated policies.

>> It is very hard to know which packet specifically triggers this. The
>> machine is under heavy load in general, a lot of packets are handled
>> via a QUEUE target, and some packets are captured via packet socket.
>
> It happens when reinjecting the packet, adding some debug code to
> ipq_issue_verdict should work.

Just about every packet goes through the QUEUE target and gets
accepted. So the amount of packets being reinjected is really high.

I guess I could catch that specific error in the places it happens and
print a dump of the packet then.

>> I will post more details tomorrow, but if you could point me towards
>> the changes in ip_conntrack that affected this, it would be very
>> helpful. I could check if they are in the Red Hat kernel and if not,
>> patch them manually and see if it makes a difference. The problem is
>> now reproduciable in a couple hours, so it shouldn't be too hard.
>
> I've attached the patch.

Thank you. I should know if it makes a difference within a few hours.

-- Naked
