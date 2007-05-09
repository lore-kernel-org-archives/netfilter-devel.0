From: "Michael Ransburg" <michael.ransburg@gmail.com>
Subject: Userspace packet queuing with libipq: ip_conntrack does not
	defragment?
Date: Wed, 9 May 2007 17:32:06 +0200
Message-ID: <22b256140705090832v556bee45ne5119d529a7e310e@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
To: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
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

Hi all,

I'm using libipq to pass certain packets to my userspace application
on Fedora 6 / Kernel 2.6.21.1 and ipTables 1.3.5.

I do:
modprobe iptable_filter
modprobe ip_queue
modprobe ip_conntrack
iptables -A INPUT -p tcp -j QUEUE

Works fine. However, since ip_conntrack is loaded I would expect that
the packets are defragmented before they are passed to my userspace
appliation (as indicated here for example:
http://lists.netfilter.org/pipermail/netfilter/2002-May/034006.html).
This does not seem the case, i.e., the maximum size of the packets
which I get (through ->data_len) is 1500 bits.

The len parameter of the ipq_read method is well over 1500, as is the
buffer size.

Any suggestions what I'm doing wrong?

Many thanks,
Michael
-- 
icq: 71772353 | skype: daneel1409 | msn: mike@unfolded.com
