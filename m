From: Tobias DiPasquale <codeslinger@gmail.com>
Subject: proper method of deleting recurring timer?
Date: Tue, 21 Sep 2004 16:20:00 -0400
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <876ef97a0409211320696001b0@mail.gmail.com>
Reply-To: Tobias DiPasquale <codeslinger@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
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
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi all,

I've seen a number of different recommendations for the proper method
of deleting a recurring timer. I am wondering what the actual proper
way is and I figured that this list is the place to find that out. I
have a timer that recurs while a module is loaded every x seconds
until the module is unloaded. What is the proper way to remove said
timer upon module unload?

Currently, I'm doing this:

[...]
del_timer_sync( &timer);
if (timer_pending( &timer))
        del_timer( &timer);
[...]

The timer is installed and started off during the module init()
function. Thanks in advance!

-- 
[ Tobias DiPasquale ]
0x636f6465736c696e67657240676d61696c2e636f6d
