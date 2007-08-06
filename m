From: "Andrew Hall" <temp02@bluereef.com.au>
Subject: conntrack clarification
Date: Mon, 6 Aug 2007 18:31:46 +1000
Message-ID: <4736426.181186389101858.JavaMail.root@localhost>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
To: <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
Content-Language: en-au
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

Hi Pablo,

I've been playing with your very cool conntrack tool and trying to use it to
forcibly remove established and related entries from the conntrack table.
The main reason I'm doing this is I want the ability to forcibly terminate a
TCP session after the access rules have been removed that allow this
connection to be established in the first place (at the moment an SSH
session - for example - remains active until the session has been closed by
the client), I can't forcibly shut the session down because I have general
"established and related" rules that allow the connection to remain open.

The problem I've found with the conntrack tool (using 'conntrack -F' to
flush the entries) is that even though the entry "appears" to get removed
for the TCP session, the entry gets re-added immediately by the session
which is still open. This is kind of counter-intuitive as once the entry is
removed I had assumed this meant the session was no longer known to be
"established" and therefore the next packet should be unrelated and dropped?
Is this correct or is there something wrong with the tool?

kernel: 2.6.22.1
libnetfilter_conntrack.so.1.2.0
libnfnetlink.so.0.2.0
conntrack v0.9.5

Thanks,
Andrew.




"Blue Reef disclaimer: This electronic message transmission contains information that is confidential or privileged. The information is intended to be for the use of the individual or entity named above. If you are not the intended recipient, be aware that any disclosure, copying, distribution, or use of the contents of this information is prohibited. If you have received this transmission in error, please notify us by telephone immediately."

Scanned by Sonar. 
Date: 2007-08-06 18:31:41
From: temp02@bluereef.com.au
To: netfilter-devel@lists.netfilter.org
Mail id: challenge-63891014970
