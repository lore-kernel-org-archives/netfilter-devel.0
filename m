From: "Amit Gupta" <agupta@ece.arizona.edu>
Subject: Compiling ip_conntrack_core.c
Date: Mon, 13 Sep 2004 12:03:28 -0700 (MST)
Sender: netfilter-devel-bounces@lists.netfilter.org
Message-ID: <3850.150.135.222.132.1095102208.squirrel@secure.ece.arizona.edu>
Mime-Version: 1.0
Content-Type: text/plain;charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: </pipermail/netfilter-devel>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
Errors-To: netfilter-devel-bounces@lists.netfilter.org
List-Id: netfilter-devel.vger.kernel.org


Hi

I am new to linux and iptables and I am working on extracting the details
of the connection information from your conntrack module, as I need
information about every connection (like packet rate, byte rate... etc)
based on the src and dst addresses and the protocol its using, but when I
try to compile ip_conntrack_core.c it gives a lot of errors, is there any
way I can fix that as the code is supplied  with the iptables module and
it is in proper working condition since it shows the right results in
/proc/net/ip_conntrack.

Please help me out as I am stuck.

Thank you
Regards

-- 
Amit Gupta
Masters Student
Elecrical and Computer Engineering
University of Arizona
Tucson (AZ)
