From: "Temp02" <temp02@bluereef.com.au>
Subject: Multiple Address specification or match
Date: Thu, 30 Sep 2004 15:09:15 +1000
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <018201c4a6ab$a1ecb6c0$2201010a@bluereef.local>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: <netfilter-devel@lists.netfilter.org>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org

Hello,

How difficult would it be to extend netfilter/iptables to allow multiple
source/destination address pairs (with negation) 'anded' together, as in -s
192.168.0.0/24 -s 10.0.0.0/8 -s ! 230.22.22.0/24. Or a match to do this same
thing?

regards,
Andrew.
