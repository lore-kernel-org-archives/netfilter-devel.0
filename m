From: Corey Giovanella <coreygiovanella@challenge-engineering.com>
Subject: New target to control a fake network interface
Date: Tue, 21 Jun 2005 02:12:33 +0000
Message-ID: <1119319953.4109.59.camel@envy>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

Hi all,

I just finished some code I've been working on and I figured I'd post a
message here incase anyone is interested in using it.

What I have done is written two new kernel modules: a fake network
interface module and a new iptables target that remote controls the
packet counters on the fake interface.  The fake interface itself, does
nothing.

The idea just kinda of came to me when I was looking at network drivers
for another idea I was thinking about.  Being able to represent packets
matched using a network interface seemed to be something that could be
useful.  I figure there are lots of programs that show graphs and things
of nic's in your computer, this would plug into them nicely.

For example I use this so I can view internet traffic separately from my
local lan traffic in Gkrellm.  

I've posted the source and perhaps a better description on my web site:
http://challenge-engineering.com/~corey/projects/fake_if/

any thoughts or feed back of any form would be appreciated.

-- 
Corey Giovanella <coreygiovanella@challenge-engineering.com>
www.challenge-engineering.com/~corey/
