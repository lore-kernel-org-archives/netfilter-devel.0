From: Dirk Morris <dmorris@metavize.com>
Subject: tcp resets w/ redirect weirdness
Date: Fri, 06 Feb 2004 13:54:09 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40240D01.8060905@metavize.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
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

This might not be the correct place to ask this, but I'm looking for any 
educated opinions.

I'm using redirect to redirect tcp connection to a local connection 
(much like squid),
and everything works great most all of the time, but occasionally it 
will reset a few connections in a row.
This happens intermittingly in 2.6.0 2.6.1 and 2.6.2. (I can't test 2.4) 
under some load. (100's of short lived connections a second)

The client connects to an outside server, the process intercepts this 
connection (via netfilter redirect),
accepts the connections, reads and then echos.

I've poured over the packet logs and can't really understand whats 
happening.

Here's a normal connection (by itself)

11:40:51.240377 10.0.0.197.49649 > 10.0.0.187.7000: S 
334841521:334841521(0) win 5840 <mss 1460,sackOK,timestamp 150107699 
0,nop,wscale 0> (DF)
11:40:51.240587 10.0.0.187.7000 > 10.0.0.197.49649: S 
2052940315:2052940315(0) ack 334841522 win 5840 <mss 
1460,nop,nop,sackOK,nop,wscale 0> (DF)
11:40:51.240611 10.0.0.197.49649 > 10.0.0.187.7000: . ack 1 win 5840 (DF)
11:40:51.240640 10.0.0.197.49649 > 10.0.0.187.7000: P 1:2(1) ack 1 win 
5840 (DF)
11:40:51.240749 10.0.0.187.7000 > 10.0.0.197.49649: . ack 2 win 5840 (DF)
11:40:51.308853 10.0.0.187.7000 > 10.0.0.197.49649: P 1:2(1) ack 2 win 
5840 (DF)
11:40:51.308881 10.0.0.197.49649 > 10.0.0.187.7000: . ack 2 win 5840 (DF)
11:40:51.308911 10.0.0.197.49649 > 10.0.0.187.7000: F 2:2(0) ack 2 win 
5840 (DF)
11:40:51.309233 10.0.0.187.7000 > 10.0.0.197.49649: F 2:2(0) ack 3 win 
5840 (DF)
11:40:51.309253 10.0.0.197.49649 > 10.0.0.187.7000: . ack 3 win 5840 (DF)

Heres what happens when things go wrong
3 new connections:
11:42:58.191055 10.0.0.197.49664 > 10.0.0.187.7000: S 
478645002:478645002(0) win 5840 <mss 1460,sackOK,timestamp 150234678 
0,nop,wscale 0> (DF)
11:42:58.191150 10.0.0.197.49665 > 10.0.0.187.7000: S 
490895753:490895753(0) win 5840 <mss 1460,sackOK,timestamp 150234678 
0,nop,wscale 0> (DF)
11:42:58.191246 10.0.0.197.49666 > 10.0.0.187.7000: S 
481978832:481978832(0) win 5840 <mss 1460,sackOK,timestamp 150234679 
0,nop,wscale 0> (DF)

11:42:58.191276 10.0.0.187.7000 > 10.0.0.197.49664: S 
2190156404:2190156404(0) ack 478645003 win 5840 <mss 
1460,nop,nop,sackOK,nop,wscale 0> (DF)
11:42:58.191312 10.0.0.197.49664 > 10.0.0.187.7000: . ack 1 win 5840 (DF)
11:42:58.191326 10.0.0.187.7000 > 10.0.0.197.49665: S 
2197261538:2197261538(0) ack 490895754 win 5840 <mss 
1460,nop,nop,sackOK,nop,wscale 0> (DF)
11:42:58.191340 10.0.0.197.49665 > 10.0.0.187.7000: . ack 1 win 5840 (DF)
11:42:58.191354 10.0.0.187.7000 > 10.0.0.197.49666: S 
2193339863:2193339863(0) ack 481978833 win 5840 <mss 
1460,nop,nop,sackOK,nop,wscale 0> (DF)
11:42:58.191366 10.0.0.197.49666 > 10.0.0.187.7000: . ack 1 win 5840 (DF)
everything looks good so far.
heres the first bit of data:
11:42:58.191474 10.0.0.197.49664 > 10.0.0.187.7000: P 1:2(1) ack 1 win 
5840 (DF)
11:42:58.191503 10.0.0.197.49665 > 10.0.0.187.7000: P 1:2(1) ack 1 win 
5840 (DF)
resend of new syn/ack, missed final ack? vv
11:42:58.191519 10.0.0.187.7000 > 10.0.0.197.49664: S 
1829257252:1829257252(0) ack 478645003 win 5792 <mss 
1460,sackOK,timestamp 584055951 150234678,nop,wscale 0> (DF)
11:42:58.191563 10.0.0.197.49664 > 10.0.0.187.7000: . ack 360899153 win 
5840 <nop,nop,sack sack 1 {0:1} > (DF)
11:42:58.191578 10.0.0.187.7000 > 10.0.0.197.49664: . ack 2 win 5840 (DF)
11:42:58.191593 10.0.0.197.49666 > 10.0.0.187.7000: P 1:2(1) ack 1 win 
5840 (DF)
11:42:58.191608 10.0.0.187.7000 > 10.0.0.197.49665: . ack 2 win 5840 (DF)
11:42:58.191672 10.0.0.187.7000 > 10.0.0.197.49666: . ack 2 win 5840 (DF)
resend of new syn/ack, missed final ack? vv
11:42:58.191707 10.0.0.187.7000 > 10.0.0.197.49665: S 
1832031209:1832031209(0) ack 490895754 win 5792 <mss 
1460,sackOK,timestamp 584055952 150234678,nop,wscale 0> (DF)
11:42:58.191726 10.0.0.197.49665 > 10.0.0.187.7000: . ack 365230330 win 
5840 <nop,nop,sack sack 1 {0:1} > (DF)
resend of new syn/ack, missed final ack? vv
11:42:58.191771 10.0.0.187.7000 > 10.0.0.197.49666: S 
1829405399:1829405399(0) ack 481978833 win 5792 <mss 
1460,sackOK,timestamp 584055952 150234679,nop,wscale 0> (DF)
11:42:58.191783 10.0.0.197.49666 > 10.0.0.187.7000: . ack 363934465 win 
5840 <nop,nop,sack sack 1 {0:1} > (DF)
then things get ugly: ..
11:42:58.191826 10.0.0.187.7000 > 10.0.0.197.49664: R 
2190156405:2190156405(0) win 0 (DF)
11:42:58.191975 10.0.0.187.7000 > 10.0.0.197.49664: R 
2190156405:2190156405(0) win 0 (DF)
11:42:58.192008 10.0.0.187.7000 > 10.0.0.197.49665: R 
2197261539:2197261539(0) win 0 (DF)
11:42:58.192081 10.0.0.187.7000 > 10.0.0.197.49664: R 
2190156405:2190156405(0) win 0 (DF)
11:42:58.192111 10.0.0.187.7000 > 10.0.0.197.49666: R 
2193339864:2193339864(0) win 0 (DF)
11:42:58.192172 10.0.0.187.7000 > 10.0.0.197.49665: R 
2197261539:2197261539(0) win 0 (DF)
11:42:58.192218 10.0.0.187.7000 > 10.0.0.197.49666: R 
2193339864:2193339864(0) win 0 (DF)
11:42:58.975362 10.0.0.187.7000 > 10.0.0.197.49665: P 
365230330:365230331(1) ack 2 win 5840 (DF)
11:42:58.975408 10.0.0.197.49665 > 10.0.0.187.7000: R 
490895755:490895755(0) win 0 (DF)
11:42:58.990356 10.0.0.187.7000 > 10.0.0.197.49664: P 
360899153:360899154(1) ack 2 win 5840 (DF)
11:42:58.990417 10.0.0.197.49664 > 10.0.0.187.7000: R 
478645004:478645004(0) win 0 (DF)
11:42:59.000321 10.0.0.187.7000 > 10.0.0.197.49666: P 
363934465:363934466(1) ack 2 win 5840 (DF)
11:42:59.000337 10.0.0.197.49666 > 10.0.0.187.7000: R 
481978834:481978834(0) win 0 (DF)

Is there some way to see why these connections are getting reset?
Or any better way to debug than just looking at these packet logs?

The kernel doesnt print out any messages.
