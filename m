From: tady@gmx.net
Subject: Re: to solve the performance problem of netfilter
Date: Wed, 17 Dec 2003 11:57:27 +0100 (MET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <32301.1071658647@www15.gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit
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

Hi there,

zhengchuanbo wrote:


> I noticed that the netfilter module has a big influnce to the performance.

> I tested the throughput of our linux firewall. the result is as follows,
> 	linux(no netfilter)					580kpps
> 	with netfilter(no ip_conntrack)	    450kpps
> 	with ip_conntrack					295kpps
> So the throughput dropped about 40% when with ip_conntrack.


I can _not_ approve your results. I'm currently running a firewall
using conntrack with much more throughput than you mentioned above. I
did an (udp only for the moment) investigation on the latency
introduced by a netfilter firewall but could not find any significant
throughput decrease.  If someone is interessted have a look at

http://rnvs.informatik.uni-leipzig.de/ipp2p/

at links and latency investigation. Currently I'm using my match at a
campus link for shaping P2P traffic but could not find any drop in
throughput of the not classified traffic.

Kind regards,
Eicke.


-- 
+++ GMX - die erste Adresse für Mail, Message, More +++
Neu: Preissenkung für MMS und FreeMMS! http://www.gmx.net
