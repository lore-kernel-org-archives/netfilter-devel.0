From: Thomas Heinz <creatix@hipac.org>
Subject: Table duplication on smp machine
Date: Mon, 31 Mar 2003 12:52:06 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E881DD6.8090206@hipac.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

Hi

Netfilter maintains different tables for each cpu which is especially
interesting for smp ;-)

This is done - according to the docs - to avoid write locking.
Now, what would be write locked in case we had only one set of
rules:

a) counters
b) match/target write operations to their match/target data

a) is clear. b) not really: if a target/match needs to store
data it would do it the way the limit match does it which
requires an in-module lock mechanism and an ugly pointer in the
private data of the match/target.

Hm, remains a). There must be another reason. Otherwise a lot
of space is wasted just to keep separate per-cpu counter values.

Is there another reason?


Regards

Thomas
