From: John Williams Floroiu <floroiu@fokus.fraunhofer.de>
Subject: iptables API
Date: Tue, 15 Jun 2004 11:56:05 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <40CEC7B5.8080001@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15; format=flowed
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


hi,

to whom it may concern, C code to invoke the iptables is available here:
http://www.mobile-ip.de/~jfl/using_iptables_API/

I used this code to remark the DSCP field of incoming datagrams, the match and target extensions 
however can be easily adapted to any needs.

note that for most cases invoking iptables commands with popen is far more convenient.

b.t.w. does anybody plan to switch this interface to netlink sockets (there have been some 
suggestions, if I remember correctly, did they materialize)?

cheers,
John.
