From: "John A. Sullivan III" <john.sullivan@nexusmgmt.com>
Subject: iptables and external processes
Date: Tue, 17 Feb 2004 16:41:53 -0500
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <1077054112.2020.12.camel@ca.gts.nexusmgmt.com>
Mime-Version: 1.0
Content-Type: text/plain
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

My apologies for troubling the develop list with such a question but I
received no reply from the user list.

It would solve a very difficult problem for us if we could jump a packet
to a chain based upon the decision of a process external to iptables. 
In other words, a packet enters the FORWARD or INPUT chains, encounters
a rule that queries a running process.  The process extracts some
information from the IP header and returns true or false.  iptables then
either matches the packet if true and passes the packet to the next rule
if false.  This sounds like the exact sort of thing a POM extension
would do.

Nothing caught my eye in either POM or the iptables documentation.  Is
this an existing functionality and I just don't see it? If not, is it
possible to write an extension that would do such a thing?  We do not
have the in-house expertise to do such a thing (obviously!) so we'll
probably need to find someone to do it for us but would like to know if
it is even possible before we pursue the matter. Thanks - John
-- 
John A. Sullivan III
Chief Technology Officer
Nexus Management
+1 207-985-7880
john.sullivan@nexusmgmt.com
