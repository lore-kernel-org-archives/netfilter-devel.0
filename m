From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: Re: iptables as a state machine
Date: Sat, 2 Oct 2004 17:01:33 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <876ef97a0410021401429a429b@mail.gmail.com>
References: <20040930193955.6fa24afc.davem@davemloft.net>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: "David S. Miller" <davem@davemloft.net>,
	netfilter-devel <netfilter-devel@lists.netfilter.org>
In-Reply-To: <20040930193955.6fa24afc.davem@davemloft.net>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

On Thu, 30 Sep 2004 19:39:55 -0700, David S. Miller <davem@davemloft.net> wrote:
> I think iptables core IP header + indev + outdev match is a
> state machine problem as well.  Such a state machine can be
> made extremely small memory wise.  The lookup can be something
> like running a berkeley packet filter on the frame.  Except
> that instead of a "yes or no" answer we get a pointer to a
> target.

What about using a n-ary PATRICIA trie to solve this problem? That
would yield O(1)-time matching of rules and the data pointer for each
node in the tree could be the list of targets that apply to that
particular IP/subnet? Not sure how ranges would work yet, though if
they didn't fit into a CIDR block...

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
