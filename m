From: Jan Engelhardt <jengelh@linux01.gwdg.de>
Subject: MARK targets all non-terminating?
Date: Wed, 6 Dec 2006 21:14:30 +0100 (MET)
Message-ID: <Pine.LNX.4.61.0612062108090.16042@yvahk01.tjqt.qr>
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

Hello list,


I just noticed that the CLASSIFY and MARK targets are non-terminating 
(as are CONNSECMARK and SECMARK as I grep). Even though that is probably 
the intended default thing, I have one setup where the following rules 
are present:

-t mangle -A POSTROUTING -p icmp -j CLASSIFY --set-class 1:10
-t mangle -A POSTROUTING -p udp -j CLASSIFY --set-class 1:11
-t mangle -A POSTROUTING -p tcp -j CLASSIFY --set-class 1:12
-t mangle -A POSTROUTING -j CLASSIFY --set-class 1:20

All packets get classified as 1:20. Per source code of xt_CLASSIFY.c 
this is justified. So what I would need is (awkward construct ahead!)

-t mangle -A POSTROUTING -p icmp -j CLASSIFY --set-class 1:10
-t mangle -A POSTROUTING -p icmp -j RETURN
-t mangle -A POSTROUTING -p udp -j CLASSIFY --set-class 1:11
-t mangle -A POSTROUTING -p udp -j RETURN
-t mangle -A POSTROUTING -p tcp -j CLASSIFY --set-class 1:12
-t mangle -A POSTROUTING -p tcp -j RETURN
-t mangle -A POSTROUTING -j CLASSIFY --set-class 1:20

Is not there a better way to do this without specifying all matches twice?


	-`J'
-- 
