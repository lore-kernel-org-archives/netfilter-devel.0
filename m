From: Thomas Heinz <creatix@hipac.org>
Subject: "Atomic" snapshot of counters
Date: Fri, 24 Jan 2003 01:35:00 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3E308A34.4020501@hipac.org>
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

Netfilter produces an atomic snapshot of counters, i.e. the table is
locked during the gathering of the counter values. Of course no packet
is matched while this lock is active.

How important is it to have such an atomic snapshot? The reason why
I'm asking this question is because Michael and I intend to implement
the nf-hipac rule listing (and especially the counter gathering)
mechanism in a way that it does not interrupt the packet matching.
This obviously implies that the counter snapshot cannot be atomic and
is therefore inaccurate in some way.
For example consider a chain A containing two rules x and y.
Now we fix the counter value of x and just before fixing the counter
value of y a packet matching x and y is processed. This packet would
only appear in the counter for y but not in the one for x.

Does this really matter or is it in fact unimportant because the error
is very marginal compared to the absolute counter values (not to forget
the performance gain).

Thanks for your rating.


Regards,

Thomas
