From: Megh Bhatt <megh.bhatt@gmail.com>
Subject: Question about Linux routing - ip_route_output_key vs fib_lookup
Date: Tue, 15 Feb 2005 09:50:32 -0500
Message-ID: <5d1f89570502150650c3e95b6@mail.gmail.com>
Reply-To: Megh Bhatt <megh.bhatt@gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
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

Hi,
I had a question about Linux routing functions, suppose I want to find
out what interface does a route to an IP address belong to - is it
better (in terms of performance) to use ip_route_output_key or
fib_lookup. My initial guess from looking at the source code is
fib_lookup since the routing cache wont be helpful since I wont have
any interface information (rather want to find out interface
information) but wanted to be sure. Thanks.

Megh Bhatt
