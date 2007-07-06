From: "Nick Landry" <nick.landry@gmail.com>
Subject: ipq_get_packet receives proper TCP and IP headers but the rest of
	payload is junk
Date: Fri, 6 Jul 2007 08:39:08 -0400
Message-ID: <9010780e0707060539y7623fbfgf2bd899a8b2f8162@mail.gmail.com>
References: <9010780e0707060538r3c754988ibebe5fa7d0c11ff2@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <9010780e0707060538r3c754988ibebe5fa7d0c11ff2@mail.gmail.com>
Content-Disposition: inline
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

I have a simple program that just reads packets off of ip_queue and
dumps them.  I setup my rules as follows:

Chain FORWARD (policy ACCEPT)
target     prot opt source               destination
QUEUE      tcp  --  anywhere             anywhere
QUEUE      udp  --  anywhere             anywhere

Everything runs fine on my 32-bit RHEL4 box and on another 64-bit
RHEL4 box.  However, when running on (yet another) 64-bit RHEL4 box I
notice that that TCP and IP header part of the payload is the same,
but the rest of the payload looks like junk (mostly null, even though
this is HTTP GET messages).

I realize I'm using an older version of iptables:
iptables-1.2.11-3.1.RHEL4
iptables-devel-1.2.11-3.1.RHEL4

But I don't see any mention of this problem for any version of iptables.

Any help would be greatly appreciated.

Nick
