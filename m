From: Jesse Lang <jlang@bureauofcollection.com>
Subject: IPTABLES port forward to port range using DNAT
Date: Mon, 3 Feb 2003 14:04:04 -0600
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <6BCA929C2000D411BE2800E018C1BB81432ECA@URS01>
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

Hey there,

I read the docs on NAT and how to forward to a range of ports on another
machine.

Here's the deal:
I have a proprietary machine that uses one client per port ports available
are let's say 2000-2299
Now, I'd like to have iptables do some magic for me where I could connect as
many clients to a port (ie 2300) on an iptables/linux box and have iptables
find the first available port in that range.  I set up forwarding and
DNAT/SNAT to accomplish this, but iptables seems to always go for the first
port 2000, whether it's in use or not.

Any help would be appreciated.  Thanks.

Jesse Lang
Information Technology
Bureau of Collection Recovery, Inc.
http://www.bureauofcollection.com/
320.214.8747 x2982

Confidentiality Note:
This message may contain confidential information that is legally privileged
and is intended only for the use of the parties to whom it is addressed. If
you are not an intended recipient, you are hereby notified that any
disclosure, copying, distribution or use of any information in this message
is strictly prohibited. If you have received this message in error, please
notify the sender immediately at the telephone number or e-mail address
noted above.
