From: Marcus Sundberg <marcus@ingate.com>
Subject: Re: ctnetlink delete conntrack performance
Date: Tue, 15 Mar 2005 19:29:24 +0100
Message-ID: <42372984.9090807@ingate.com>
References: <422C3A1B.5080604@ingate.com> <422C5370.9050204@trash.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: Patrick McHardy <kaber@trash.net>
In-Reply-To: <422C5370.9050204@trash.net>
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
> Marcus Sundberg wrote:
> 
>> When the CTNL_MSG_DELCONNTRACK function of the ctnetlink patch is
>> used it calls ip_ct_selective_cleanup() to remove the conntrack.
>>
>> This is highly ineffective (depending on how many hash buckets you
>> have ofcourse - I had 131007 of them when performing the test :-)
>>
>> Is there any reason I'm missing (except that maybe the code should
>> go into it's own function) for not simply doing it this way:
> 
> 
> You can't drop the reference before calling the timeout function.

Makes sense ofcourse, so just reversing the calls should be fine?

> BTW: There is no ip_ct_death_by_timeout() AFAICT. Can you send a
> new patch ?

Sure, what is the prefered form? There are currently two versions of the
original patch in netfilter SVN: netfilter-ha/patches/nfnetlink-ctnetlink.patch
and patch-o-matic-ng/nfnetlink-ctnetlink-0.13. Do you prefer a patch against
any of the patches, a patch replacing any of them, or a patch against the
patched code? :-)

Also, is there anyone else working on ctnetlink currently, or planning
to work on it? Is the goal to get it into the standard kernel, and if
so what must be done before that?

//Marcus
-- 
---------------------------------------+--------------------------
   Marcus Sundberg <marcus@ingate.com>  | Firewalls with SIP & NAT
  Software Developer, Ingate Systems AB |  http://www.ingate.com/
