From: Peter Surda <shurdeek@routehat.org>
Subject: ipset -L causing kernel panic when using macipmap
Date: Fri, 03 Dec 2004 15:48:56 +0100
Message-ID: <41B07CD8.8080800@routehat.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
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

Hello,

I don't know if this is the correct mailing list for ipset, but there 
doesn't seem to be much other information online so I'm trying it here.

I'm using kernel 2.4.26, iptables 1.2.11 and ipset 1.0 (at least I think 
it is 1.0, changelog claims this) and am playing with it a little.

Using ipmap, everything seems to work fine. When I use macipmap however, 
-L causes a kernel panic immediately without any output from ipset 
itself. It happens regardless of the number of elements, I tested it 
with 0, 2 and 3. Other commands, like -A or -T seem to work correctly 
though.

Exact way to reproduce:
modprobe ip_set
modprobe ip_set_macipmap
ipset -N lan macipmap --network 10.0.0.0/24
# I also tried --from, --to and --network 10.0.0.0/255.255.255.0 with 
the same results
ipset -L
# immediate panic

As I said, when I do the same with ipmap instead of macipmap, everything 
seems to work ok.

Is this perhaps know and fixed in cvs or something? If not, I could do 
some more tests or post more details if I know which ones, or try to 
debug it myself.

Yours sincerely,

shurdeek
