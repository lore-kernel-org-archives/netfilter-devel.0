From: Bogaerts Bart <Bart.Bogaerts@siemens.com>
Subject: libipq
Date: Mon, 11 Aug 2003 15:05:40 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <57FD2C3A246F76438CA6FDAD8FE9F195C7E76E@hrtades7.atea.be>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="iso-8859-1"
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: "'netfilter-devel@lists.netfilter.org'"
	 <netfilter-devel@lists.netfilter.org>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I have written a UserApplication which changes some payload into certain
messages. 
When I send with netcat messages sequential to netfilter all the messages
are passed through netfilter, but when I
send multiple messages to netfilter, I can see that my application get all
the messages adapt this messages 
and calls for every messages the set_verdict function but not all the
messages are appearing on the outgoing interface.

I'm using kernel 2.4.20 and iptables 1.2.6a

What exactly happens when a adapted packet is reinjected via nf_reinject ?
After leaving the POSTROUTING hook the packet is sent to where ?


With friendly greetings,
Bart
