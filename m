From: Menno Smits <menno@netboxblue.com>
Subject: early_drop() not working correctly?
Date: Thu, 06 Jul 2006 15:24:16 +0100
Message-ID: <44AD1D10.6000208@netboxblue.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel <netfilter-devel@lists.netfilter.org>
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

Hi list,

At one customer site we have a situation where a netfilter box sees half 
  of some connections due to asymmetric routing. This causes lots of 
ESTABLISHED but unreplied connections to fill the conntrack table with 
long (5 day) timeouts. Eventually the table completely fills up. The 
"nf_conntrack: table full, dropping packet" message is reported, packets 
  are dropped and the customer starts complaining.

According to discussions with Patrick McHardy off list and my own 
examinations of the code, early_drop() should free up some of the 
conntrack table when the table is full by removing unreplied 
connections. In practice, this doesn't actually happen.

I've experimented with a similar setup in the office and I can 
consistently replicate the problem. I'm happy to describe my test setup 
if anyone is interested (it's a little complicated).

Can someone explain why the unreplied connections aren't being removed 
from the conntrack table? Is there a bug here?

Regards,
Menno

ps. We have worked around the issue at the client's site by using the 
NOTRACK target for the asymmetrically routed traffic. Turning off TCP 
connection pickup also works around the problem.
