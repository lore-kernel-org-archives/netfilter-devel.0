From: Tim Burress <tim@variosecure.net>
Subject: Out-of-Window RST Problem?
Date: Thu, 23 Jun 2005 10:54:17 +0900
Message-ID: <42BA1649.7020907@variosecure.net>
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

We're using 2.4.30 with TCP window tracking on a box that acts as a 
router, and have been seeing situations where some client systems, 
notably some incarnation of Windows XP SP2 with IE 6.0, are sending RST 
segments with what appear to be incorrect ack sequence numbers. These 
are dropped as out-of-window by Netfilter, with the result that 
connections hang and everybody gets upset. Here is the relevant snippet 
of an example session:

1    16:17:06.441369 IP server.1935 > client.48415: P 3465:3931(466) ack 
3641 win 11680
2    16:17:06.597107 IP client.48415 > server.1935: . ack 3931 win 64525
3    16:17:10.034881 IP client.48415 > server.1935: P 3641:3683(42) ack 
3931 win 64525
4    16:17:10.035085 IP client.48415 > server.1935: R 3684:3684(0) ack 
3932 win 1024
5    16:17:10.073142 IP server.1935 > client.48415: . ack 3683 win 11680

So, you can see on line 4 that the ack sequence number in the RST sent 
by the client (caused by a "Stop" click in the browser) has inexplicably 
been incremented from the previous value. For that matter, so has the 
send sequence number, though at least it's in the server's window.

It seems obvious that it's a Microsoft issue of some kind, so I really 
should try talking to them (if they do, in fact, talk to people), but I 
thought I would ask about it here first because (1) the standards are a 
little obscure about unprovoked ("lazy close") RST handling and I may be 
wrong in blaming Microsoft, and (2) given the apparent popularity of XP 
it seems like it might be something of interest to this group, and of 
course (3), I wondered if anyone have seen it before and perhaps knows 
of a fix.

I should say that we have not been able to reproduce this locally, so 
there may well be other factors involved besides the combination of OS 
and browser. Perhaps some update that has not been applied. 
Unfortunately we don't have access to the client system, or even direct 
communication with its owner.

Tim
