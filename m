From: "Sean Donner" <siegex@atozcomp.com>
Subject: Port Cloaking
Date: Fri, 19 Nov 2004 10:51:06 -0800 (PST)
Message-ID: <57701.67.122.205.47.1100890266.squirrel@67.122.205.47>
Reply-To: siegex@atozcomp.com
Mime-Version: 1.0
Content-Type: multipart/mixed;boundary="----=_20041119105106_85504"
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

------=_20041119105106_85504
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: 8bit

Now that I have ported the random match to 2.6.X, I wanted to talk to you
guys about how I use it and see if you had any tips to improve on my idea.
 I came up with this idea not too long ago about having iptables spoof the
state of a port, whether its open or closed.  Combining this with the
port-scan-detection and random matches, my goal was to make it so that
when my box is being portscanned, the attacker would see various ports as
open even if they were really closed, and all of my truely open ports
would be filtered/stealthed.  With the help of the random match, every
time my box is portscanned (even by the same attacker) the would see a
whole new set of fake ports as open.

The only way I could think of, that would allow a closed port to fake as
if it were open was to write a very small "dummy server" that does nothing
but bind to an arbitrary port.  Once bound, I would send all psd matched
packets to that dummy server port via REDIRECT.  So here is the flow.

1) Attacker runs a port scan againt my box
2) Port-scan-detection threshold reached, packets sent to portcloak_random
chain
3) Check to see if packet is destined to a truley open port, if so drop it.
4) Randomly match remaining packets with a 1% average and send them to the
dummy server listening on $DUMMYPORT via REDIRECT.
5) Drop all remaining packets.

Here is how I implimented it:

-----------------------
-t nat -N portcloak_random
-t nat -A PREROUTING -p tcp -i $EXT_NET -m psd --psd-delay-threshold 2000
-j portcloak_random

-t nat -A portcloak_random -p tcp -m multiport --destination-ports `echo
$SINGLE_PORTS | sed 's/\ /,/g'` -j DROP
-t nat -A portcloak_random -p tcp -m random --average 1 -j REDIRECT
--to-ports $DUMMYPORT
-t nat -A portcloak_random -j DROP
-----------------------

One thing to note, $SINGLE_PORTS expands to the truely open ports on my box.

Using this implimentation ive had some very positive results but there are
some drawbacks that I hope you guys could help remedy.

1) First and foremost, if at all possible I would like to get rid of the
need to have a dummy server and do the entire thing using iptables rules.

2) This implimentation only works against half open portscans (nmap -sS)
and not with a full TCP handshake scan (nmap -sT). Im guessing because the
final ACK packet from the attacker will be dropped 99% of the time thanks
to the random match, and thats assuming it gets past the
port-scan-detection match.

I was thinking that a possible fix for this is to use the CONNMARK
match/target within the portcloak_random chain and mark all connections
that  are sent to the dummy server.  Then, add an additional rule before
the port-scan-detection rule that will REDIRECT any packet with the
correct CONNMARK to the dummy server.   Havn't tried this out yet, cause
ive had problems with CONNMARK compiling on 2.6.X.

3) Assuming #1 is not possible, every time one of the scans connects to my
dummy server that uses up resources, both from conntrack as well as kernel
mem for the sockets.  I pretty much borrowed the dummy_server.c code from
a network programming howto, so if any of you feel like taking a once over
on it and seeing if you see any blatent security risks that can lead to an
easy DoS of my box, or see some way to make it more efficient with the
resources it uses I would appreciate it; the code is fairly short.  All it
has to do is just bind to a port.

Sorry for the lengthy post, I appreciate all comments.  My dummy_server.c
code is attached.

-Sean
------=_20041119105106_85504
Content-Type: application/octet-stream; name="dummy_server.c"
Content-Transfer-Encoding: base64
Content-Disposition: attachment; filename="dummy_server.c"

IC8qCiAgICAqKiBzZXJ2ZXIuYyAtLSBhIHN0cmVhbSBzb2NrZXQgc2VydmVyIGRlbW8KICAgICov
CgogICAgI2luY2x1ZGUgPHN0ZGlvLmg+CiAgICAjaW5jbHVkZSA8c3RkbGliLmg+CiAgICAjaW5j
bHVkZSA8dW5pc3RkLmg+CiAgICAjaW5jbHVkZSA8ZXJybm8uaD4KICAgICNpbmNsdWRlIDxzdHJp
bmcuaD4KICAgICNpbmNsdWRlIDxzeXMvdHlwZXMuaD4KICAgICNpbmNsdWRlIDxzeXMvc29ja2V0
Lmg+CiAgICAjaW5jbHVkZSA8bmV0aW5ldC9pbi5oPgogICAgI2luY2x1ZGUgPGFycGEvaW5ldC5o
PgogICAgI2luY2x1ZGUgPHN5cy93YWl0Lmg+CiAgICAjaW5jbHVkZSA8c2lnbmFsLmg+CgogICAg
dm9pZCBzaWdjaGxkX2hhbmRsZXIoaW50IHMpCiAgICB7CiAgICAgICAgd2hpbGUod2FpdChOVUxM
KSA+IDApOwogICAgfQoKICAgIHZvaWQgdXNhZ2UoY2hhciAqcHJvZ25hbWUpIAogICAgewogICAg
ICAgZnByaW50ZihzdGRlcnIsICJ1c2FnZTogJXMgPGxpc3Rlbl9wb3J0PiA8bWF4X2Nvbm5lY3Rp
b25zX2luX3F1ZXVlPlxuIixwcm9nbmFtZSk7CiAgICB9CgogICAgaW50IG1haW4oaW50IGFyZ2Ms
IGNoYXIgKmFyZ3ZbXSkKICAgIHsKICAgICAgICBpbnQgbXlwb3J0OyAgLy8gdGhlIHBvcnQgdXNl
cnMgd2lsbCBiZSBjb25uZWN0aW5nIHRvCgkJICBpbnQgYmFja2xvZzsgIC8vIGhvdyBtYW55IHBl
bmRpbmcgY29ubmVjdGlvbnMgcXVldWUgd2lsbCBob2xkCgkJICBpbnQgc29ja2ZkLCBuZXdfZmQ7
ICAvLyBsaXN0ZW4gb24gc29ja19mZCwgbmV3IGNvbm5lY3Rpb24gb24gbmV3X2ZkCgkJICBzdHJ1
Y3Qgc29ja2FkZHJfaW4gbXlfYWRkcjsgICAgLy8gbXkgYWRkcmVzcyBpbmZvcm1hdGlvbgogICAg
ICAgIHN0cnVjdCBzb2NrYWRkcl9pbiB0aGVpcl9hZGRyOyAvLyBjb25uZWN0b3IncyBhZGRyZXNz
IGluZm9ybWF0aW9uCiAgICAgICAgaW50IHNpbl9zaXplOwogICAgICAgIHN0cnVjdCBzaWdhY3Rp
b24gc2E7CiAgICAgICAgaW50IHllcz0xOwoKCWlmKGFyZ2MgIT0gMyl7IAkvLyBJZiB0aGUgY29y
cmVjdCBudW1iZXIgb2YgYXJndW1lbnRzIGFyZSBub3QgcGFzc2VkLCBzaG93IHVzYWdlKCkKICAJ
ICAgdXNhZ2UoYXJndlswXSk7CiAgCSAgIGV4aXQoMCk7Cgl9CgogICAgICAgIGlmICgoc29ja2Zk
ID0gc29ja2V0KEFGX0lORVQsIFNPQ0tfU1RSRUFNLCAwKSkgPT0gLTEpIHsKICAgICAgICAgICAg
cGVycm9yKCJzb2NrZXQiKTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CgogICAgICAg
IGlmIChzZXRzb2Nrb3B0KHNvY2tmZCxTT0xfU09DS0VULFNPX1JFVVNFQUREUiwmeWVzLHNpemVv
ZihpbnQpKSA9PSAtMSkgewogICAgICAgICAgICBwZXJyb3IoInNldHNvY2tvcHQiKTsKICAgICAg
ICAgICAgZXhpdCgxKTsKICAgICAgICB9CgoJbXlwb3J0ID0gYXRvaShhcmd2WzFdKTsKCWJhY2ts
b2cgPSBhdG9pKGFyZ3ZbMl0pOwogICAgICAgIAogICAgICAgIG15X2FkZHIuc2luX2ZhbWlseSA9
IEFGX0lORVQ7ICAgICAgICAgLy8gaG9zdCBieXRlIG9yZGVyCiAgICAgICAgbXlfYWRkci5zaW5f
cG9ydCA9IGh0b25zKG15cG9ydCk7ICAgICAvLyBzaG9ydCwgbmV0d29yayBieXRlIG9yZGVyCiAg
ICAgICAgbXlfYWRkci5zaW5fYWRkci5zX2FkZHIgPSBJTkFERFJfQU5ZOyAvLyBhdXRvbWF0aWNh
bGx5IGZpbGwgd2l0aCBteSBJUAogICAgICAgIG1lbXNldCgmKG15X2FkZHIuc2luX3plcm8pLCAn
XDAnLCA4KTsgLy8gemVybyB0aGUgcmVzdCBvZiB0aGUgc3RydWN0CgogICAgICAgIGlmIChiaW5k
KHNvY2tmZCwgKHN0cnVjdCBzb2NrYWRkciAqKSZteV9hZGRyLCBzaXplb2Yoc3RydWN0IHNvY2th
ZGRyKSkgPT0gLTEpIHsKICAgICAgICAgICAgcGVycm9yKCJiaW5kIik7CiAgICAgICAgICAgIGV4
aXQoMSk7CiAgICAgICAgfQoKICAgICAgICBpZiAobGlzdGVuKHNvY2tmZCwgYmFja2xvZykgPT0g
LTEpIHsKICAgICAgICAgICAgcGVycm9yKCJsaXN0ZW4iKTsKICAgICAgICAgICAgZXhpdCgxKTsK
ICAgICAgICB9CgogICAgICAgIHNhLnNhX2hhbmRsZXIgPSBzaWdjaGxkX2hhbmRsZXI7IC8vIHJl
YXAgYWxsIGRlYWQgcHJvY2Vzc2VzCiAgICAgICAgc2lnZW1wdHlzZXQoJnNhLnNhX21hc2spOwog
ICAgICAgIHNhLnNhX2ZsYWdzID0gU0FfUkVTVEFSVDsKICAgICAgICBpZiAoc2lnYWN0aW9uKFNJ
R0NITEQsICZzYSwgTlVMTCkgPT0gLTEpIHsKICAgICAgICAgICAgcGVycm9yKCJzaWdhY3Rpb24i
KTsKICAgICAgICAgICAgZXhpdCgxKTsKICAgICAgICB9CgogICAgICAgIHdoaWxlKDEpIHsgIC8v
IG1haW4gYWNjZXB0KCkgbG9vcAogICAgICAgICAgICBzaW5fc2l6ZSA9IHNpemVvZihzdHJ1Y3Qg
c29ja2FkZHJfaW4pOwogICAgICAgICAgICBpZiAoKG5ld19mZCA9IGFjY2VwdChzb2NrZmQsIChz
dHJ1Y3Qgc29ja2FkZHIgKikmdGhlaXJfYWRkciwmc2luX3NpemUpKSA9PSAtMSkgewogICAgICAg
ICAgICAgICAgcGVycm9yKCJhY2NlcHQiKTsKICAgICAgICAgICAgICAgIGNvbnRpbnVlOwogICAg
ICAgICAgICB9CiAgICAgICAgfQoKICAgICAgICByZXR1cm4gMDsKICAgIH0gCg==
------=_20041119105106_85504--
