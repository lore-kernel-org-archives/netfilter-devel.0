From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: rp_filtering
Date: Mon, 11 Jul 2005 19:50:32 +0200 (MEST)
Message-ID: <Pine.LNX.4.61.0507111946560.32325@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Netfilter Developer Mailing List <netfilter-devel@lists.netfilter.org>
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


rp_filter is said to be a route path verification (etc.)

  ippp0  217.245.127.134
  eth0   192.168.222.1

However, I've just done a ping 217.245.127.134 from a windows client inside 
the eth0 network, took a peek at iptraf and saw that echo requests and replies 
were directly going from/to eth0/192.168.222.34(windows).

That means someone could send a srcip=192.168.222.1 dstip=217.245.127.134 
packet to me on ippp0, could it? Or where is the verification...


Jan Engelhardt
-- 
