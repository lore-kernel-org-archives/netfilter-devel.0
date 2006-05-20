From: "Vladimir S. Petukhov" <vladimir@sycore.org>
Subject: Iptables load balancing
Date: Sat, 20 May 2006 14:49:56 +0400
Message-ID: <200605201449.56621.vladimir@sycore.org>
Reply-To: vladimir@sycore.org
Mime-Version: 1.0
Content-Type: text/plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-bounces@lists.netfilter.org>
To: netfilter@lists.netfilter.org,
	netfilter-devel@lists.netfilter.org
Content-Disposition: inline
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter>
List-Post: <mailto:netfilter@lists.netfilter.org>
List-Help: <mailto:netfilter-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter>,
	<mailto:netfilter-request@lists.netfilter.org?subject=subscribe>
Sender: netfilter-bounces@lists.netfilter.org
Errors-To: netfilter-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hi!

Sorry for my English...

I need to separate UDP packets  via several ports according content of these 
packets. Each packet has fixed field  (2 bytes) - "connection" number 
(session number), packet with the same number must be forwarded on the same 
port. It look like NAT, but based on content of UDP packet.

Thanks!
