From: Patrick McHardy <kaber@trash.net>
Subject: Re: [RFC] Die to NOTRACK/TRACE, long live MARK!
Date: Fri, 21 May 2004 04:12:43 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40AD659B.7090107@trash.net>
References: <Pine.LNX.4.33.0405192236590.3749-100000@blackhole.kfki.hu> <40AD4B36.50202@snapgear.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Jozsef Kadlecsik <kadlec@netfilter.org>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <40AD4B36.50202@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

Philip Craig wrote:
> Jozsef Kadlecsik wrote:
> 
>> We could introduce a new silly target for that purpose like NOTRACK or
>> TRACE. However it's pure marking and we do have a interface to mark
>> packets: the MARK target. So if we could tell the system which mark value
>> has got the given special meaning, we wouldn't need a new target and we
>> could even eliminate the NOTRACK/TRACE targets.
> 
> 
> I assume this will mean allowing the MARK target to be used in the raw
> table, otherwise you can't mark the packets before conntrack.
> 
> Will this mean that only one of these features can be used at a time,
> since a packet cannot have multiple marks?  And use of any of these
> features would preclude current uses of MARK, such as policy routing?
> You could add support for masking bits of the mark, but you would have
> to add this to the policy routing also.

Instead of modifying the nf_mark value (which I don't think we should
do), we could just let the mark target perform the same operations that
NOTRACK/TRACE perform, namely attaching a dummy-conntrack (NOTRACK)
and setting a bit in nfcache (TRACE). For the tcp-window-tracking
spoofed-rst protection we could set a bit in the conntrack structure.
I suppose this feature need to be enabled on a per-connection base
anyway. Unfortunately adding NOTRACK functionality to MARK in this
way would create a dependency on ip_conntrack. Maybe we should add
it to CONNMARK ?

Regards
Patrick

PS: Joszef, I changed your address to @netfilter.org, your mailserver
doesn't like me.

PPS: I'll be away 'till Sunday so don't expect fast responses
