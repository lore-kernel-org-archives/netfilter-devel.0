From: Nagaraj G <gnraj@teneoris.com>
Subject: Can I create an Incoming Connection from NAT which goes through NAT
Date: Wed, 18 Feb 2004 16:54:23 +0530
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1077103462.3772.7.camel@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Netfilter <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello Everyone,

I am facing a major problem using the Linux NAT. I am having Linux
2.4.10 with netfilter.

I have a NAT Application for which I hook my Standalone NAT Module on
that port (STANDALONE and ALWAYS_NAT). I don't have a
connection-tracking module as I don't get a reply packet on the original
connection.

I want to open an Incoming connection for a specific destination and all
the packets that are destined to that port should go through my NAT
Helper.

Is this possible at all using netfilter NAT?

I tried creating a connection using expect_related. But only the first
packet goes through my Nat_Expected function. But none of the packets
come to my NAT helper even though I have registered for NAT for that
port.

Is there any way by which I create an Incoming connection which goes
through my NAT helper?

Netfilter being so popular, there should be a way to do this. But I
didn't see such details in any documentation available.

Am I missing something?

Please..please...help!!!

Thanks a lot in advance...

Best Regards,

Nagaraj
