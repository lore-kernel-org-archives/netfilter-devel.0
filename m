From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Re: the solution to synflood on netfilter
Date: Thu, 08 Jan 2004 14:50:41 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FFD5221.10503@netlab.hut.fi>
References: <Pine.LNX.4.44.0312270100360.9836-100000@filer.marasystems.com>
Reply-To: emmanuel@netlab.hut.fi
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: "netfilter-devel@lists.netfilter.org"
 <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org


Hi!

Sorry to intervene so late on that subject, I was in holiday.
There is a now quite old paper (1997) that fits exactly with the ideas 
that were expressed and I think you should have a look at it:
C.L. Schuba, I.V. Krsul, M.G. Kuhn, E.H. Spafford, A. Sundaram, and D. 
Zamboni, "Analysis of a denial of service attack on TCP," in /Proc. IEEE 
Symposium on Security and Privacy 1997/, May 4-7, 1997, pp. 208-223.
As far as I know, it was one of the first paper published on the subject 
and there are a few proposed solutions with their issues. It includes 
the two solutions mentioned at first in the previous mails.
About the establishing "illegitimate connections" case, well it worth 
doing when considering that the processing power/memory needed to take 
care of the illegitimate connections has more capacity than the backlog 
queue can accept half-open connections.

Bye,

         Emmanuel
