From: Emmanuel Guiton <emmanuel@netlab.hut.fi>
Subject: Counter problem in a new nat target.
Date: Mon, 08 Dec 2003 13:53:28 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD46638.5000300@netlab.hut.fi>
Reply-To: emmanuel@netlab.hut.fi
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

Hi!

I need to include a counter in my new nat target function (basically to 
know how many connections for a particular target are curently 
registered in the nat table). I had first though about including a 
simple integer in my targinfo, but I just noticed that it is passed to 
the target function as a const. Thus it does not work.
Does someone has a good advice on where I can store my variable? Can I 
use the void *userdata ? (I do not really know to what it points).

Thanks,

          Emmanuel
