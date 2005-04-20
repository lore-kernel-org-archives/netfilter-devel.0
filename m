From: Patrick McHardy <kaber@trash.net>
Subject: Re: [PATCH] Fix NAT TCP sequence adjustment
Date: Wed, 20 Apr 2005 17:03:40 +0200
Message-ID: <42666F4C.5080706@trash.net>
References: <20050402202438.GA2968@linuxace.com>
	<4250435E.1090309@trash.net>	<20050403235320.GB28850@linuxace.com>	<20050404044033.GA1847@linuxace.com>
	<4250FA72.3020502@trash.net>	<20050404204716.GA4067@linuxace.com>	<20050406044806.GA9711@linuxace.com>
	<4263108E.1030707@trash.net> <20050419005847.GA591@linuxace.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>, Rusty Russell <rusty@rustcorp.com.au>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Phil Oester <kernel@linuxace.com>
In-Reply-To: <20050419005847.GA591@linuxace.com>
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
> If not, can you provide some sample seq/o_a/o_b numbers which you believe
> would fail this test? 

offset_before: 1000
offset_after: -1000
correction_pos: 1000000

Sequence number (pre-adjustment): 999500 (retransmit)
Sequence number (post-adjustment): 1000500

if (seq - this_way->offset_before != this_way->correction_pos)

adjusted seq - offset_before = 999500 => passes the test
adjusted seq - offset_after = 1001500 => not detected as retransmit.

You assume only identical retransmits of the packet that caused
the last adjustment. It could also be an older packet or have
different boundaries. This brings us to a different problem,
the sequence number at which the correction occured should be
stored, not the first sequence number contained in the packet.
But this can be done in a seperate fix.

Regards
Patrick
