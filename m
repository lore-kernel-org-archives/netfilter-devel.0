From: Chris Green <cmg@dok.org>
Subject: Logging NAT translations?
Date: Wed, 28 Jul 2004 17:07:41 -0400
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <87isc7on6q.fsf@ion.xlipstream.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hey folks,

Is there a way to log the translations that occur in the NAT table?

I'd prefer an something along the lines of listening to a netlink
socket but I'm having a hard time finding information on doing this.
If this doesn't exist already, can anyone give me pointers on
implementing it?

The closest I've found is nfnetlink-ctnetlink.  Anyone know what the
status of this is?  I know it doesn't work with 2.6 and I've been told
it doesn't work with recent 2.4s either.

Cheers,
Chris
-- 
Chris Green <cmg@dok.org>
You now have 14 minutes to reach minimum safe distance.
