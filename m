From: Martin Josefsson <gandalf@wlug.westbo.se>
Subject: [Fwd: Connection tracking - CLOSE_WAIT and FIN_WAIT]
Date: 10 Apr 2003 16:09:53 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1049983793.11132.20.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Cc: dhiraj.2.bhuyan@bt.com
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter-devel <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Forwarded to the correct list.

Please subscribe if you are going to post to this list since it's a
closed list.

-----Forwarded Message-----

From: dhiraj.2.bhuyan@bt.com
To: netfilter@lists.netfilter.org
Subject: Connection tracking - CLOSE_WAIT and FIN_WAIT
Date: 10 Apr 2003 14:54:26 +0100

Hello list,

I just carried out a couple of tests to see how conntrack changes the state
of a TCP stream -

----------- test 1 -------------------------------------------------
1. (A) ---->SYN----->(B)  FW state = SYN_SEND
2. (A) <---SYN+ACK-- (B)  FW state = SYN_RECV
3. (A) -----ACK----->(B)  FW state = ESTABLISHED (ASSURED)

4. (A) --->FIN+ACK-->(B)  FW state = FIN_WAIT
5. (B) <-----ACK---- (B)  FW state = TIME_WAIT (times out after 2 mins)

----------- test 2 -------------------------------------------------
1. (A) ---->SYN----->(B)  FW state = SYN_SEND
2. (A) <---SYN+ACK-- (B)  FW state = SYN_RECV
3. (A) -----ACK----->(B)  FW state = ESTABLISHED (ASSURED)

4. (A) <---FIN+ACK-- (B)  FW state = CLOSE_WAIT
5. (B) -----ACK----> (B)  FW state = TIME_WAIT (times out after 2 mins)



Now step (4) of test 1 leads to FIN_WAIT state, but step (4) of test 2 leads
to CLOSE_WAIT.
The only difference between the two is the direction of packet flow. So the
question - is this the expected behaviour? If yes, what is the purpose?


dhiraj
