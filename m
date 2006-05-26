From: Dirk <noisyb@gmx.net>
Subject: How to block traffic country-wise?
Date: Fri, 26 May 2006 23:54:34 +0200
Message-ID: <4477791A.5070100@gmx.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
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
I want to write a firewall that can block traffic from specific
countries using GeoIP.dat.

I downloaded libnetfilter_queue because I think it can do what I want.

1) Get IP of connection
2) Check local GeoIP database
3) Refuse or Allow connection

But the included examples don't work. Maybe I'm completely wrong by
starting with libnetfilter_queue or the included example?

Can someone give me a hint, example, snippet or link?

Thanks,
Dirk
