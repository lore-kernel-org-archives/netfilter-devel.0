From: Amin Azez <azez@ufomechanic.net>
Subject: conntrack session information
Date: Wed, 20 Apr 2005 13:11:14 +0100
Message-ID: <426646E2.5040504@ufomechanic.net>
References: <20050418173034.0372.LARK@linux.net.cn>	<4263D3B2.1090308@ufomechanic.net>
	<20050419000157.038C.LARK@linux.net.cn>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Pablo Neira <pablo@eurodev.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <20050419000157.038C.LARK@linux.net.cn>
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


Wang Jian wrote:
> There is problem to create whole sessions record from events. event
> messages should carry necessary information for correlation

I'm proposing that we base this session id on a 64 bit counter.
I will also want to adjust conntrack to record the system time at which 
the conntrack was created anyway.

If we also associate with this a serial number, the chances "in normal 
use" that the counter will wrap around with the same system time are 
miniscule.

For most purposes the connection serial number is unique, but the 
associated timestamp makes it historically unique.

Final question, I suppose that ip_conntrack.master references will cause 
the master conntrack (of related conntracks) to hang around until the 
related conntracks have been deleted? Thus, the netlink stuff can report 
the id of the master conntrack when it reports other conntrack info.

Does this sound reasonable to folk? Is this too much overheard per 
conntrack? What bottlenecks are there?

Maybe it would require a cross-cpu counter with serialized access. Is 
there a standard kernel form for this, or do we use spinlocked structs 
or something? Or is a per-cpu counter preferred, combined with a CPU-id?

Amin
