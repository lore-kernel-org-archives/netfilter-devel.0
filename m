From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: Maintenance for POM-ng modules
Date: Wed, 6 Dec 2006 21:48:42 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612062122410.16042@yvahk01.tjqt.qr>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: kaber@netfilter.org
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



connlimit:
As of r6652, it has been moved to external. I would like to see it in 
pomng again (or even mainline kernel).

XOR:
Removed as of r6598, reason: no maintainer. I am currently maintaining 
it in private, just for the fun of it.

unclean:
Also deleted as of r6598. I would like to revive this module since it 
will be useful to us.

So, given this short summary, I would like to take these three projects 
and bring them back into shape (they really don't need a lot fixing 
AFAICT).
What's the preferred procedure?



Thanks,
	-`J'
-- 
