From: Michal Ludvig <mludvig@suse.cz>
Subject: Re: NAT before IPsec with 2.6
Date: Fri, 23 Jan 2004 14:31:47 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40112243.2060401@suse.cz>
References: <Pine.LNX.4.44.0401231329250.12080-100000@filer.marasystems.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Henrik Nordstrom <hno@marasystems.com>
In-Reply-To: <Pine.LNX.4.44.0401231329250.12080-100000@filer.marasystems.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Henrik Nordstrom told me that:
> On Wed, 21 Jan 2004, Michal Ludvig wrote:
> 
>>So I hacked up this simple solution - I understand that it won't be 
>>accepted as-is, because now the POSTROUTING chain is reached twice (once 
>>from ip_forward and once from ip_output). But anyways - is this a 
>>correct approach and should I go this way with some cleanups?
> 
> The ip_forward call should be moved to just before where the packets gets
> encapsulated when using IPSec. When using IPSec this is the conceptual 
> POSTROUTING point in the stack for the plain packets.

Without my patch the path is:

	ip_forward()
	     |
	check xfrm policy (here it's decided whether or not to encrypt)
	     |
	NF_IP_FORWARD (unfortunately no NAT available here...)
	     |
	ip_forward_finish()
	     |
	dst_output() => esp_output()

With my patch the path is:

	ip_forward()
	     |
	check xfrm policy (could probably be omitted, we'll do it after
	                   NAT once again)
	     |
	NF_IP_FORWARD (the packet may be e.g. dropped here)
	     |
	ip_forward_postroute()
	     |
	NF_IP_POST_ROUTING (do NAT here)
	     |
	ip_forward_finish()
	     |
	check xfrm policy (here it's decided whether or not to encrypt)
	     |
	dst_output() => esp_output()

I.e. the postrouting on the unencrypted packet is really called right 
before it gets encrypted. And the encrypted packet then hits the 
POSTROUTING again, but it's already a different packet, actually.

Was this your point or did I misunderstand you?

Michal Ludvig
-- 
SUSE Labs                    mludvig@suse.cz | Cray is the only computer
(+420) 296.545.373        http://www.suse.cz | that runs an endless loop
Personal homepage http://www.logix.cz/michal | in just four hours.
