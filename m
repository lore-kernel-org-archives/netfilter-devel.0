From: James Morris <jmorris@namei.org>
Subject: [RFC] SECMARK 1.0 (fwd)
Date: Sun, 7 May 2006 13:45:47 -0400 (EDT)
Message-ID: <Pine.LNX.4.64.0605071345140.9423@d.namei>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
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

(forwarding with the correct list address)

---------- Forwarded message ----------
Date: Sun, 7 May 2006 11:31:38 -0400 (EDT)
From: James Morris <jmorris@namei.org>
To: selinux@tycho.nsa.gov
Cc: netdev@vger.kernel.org, netfilter-devel@lists.samba.org,
    Stephen Smalley <sds@tycho.nsa.gov>, Daniel J Walsh <dwalsh@redhat.com>
Subject: [RFC] SECMARK 1.0

The following patchsets implement a new scheme for adding security 
markings to packets via iptables, as well as changes to SELinux to use 
these markings for security policy enforcement.

Along with these patches, assorted files including policy examples and 
patches for SELinux userland may be found at:
http://people.redhat.com/jmorris/selinux/secmark/

The requirements for secmark arise from the current per-packet network 
controls in SELinux, which are rudimentary, and not as expressive or 
powerful as the controls provided by Netfilter/iptables.

Thus, the idea is to leverage Netfilter/iptables for packet selection and 
labeling, so that SELinux can have more powerful and expressive network 
controls.  This also allows for increased security, as the policy is more 
effective, allowing access to the full range of iptables selectors and 
support mechanisms.

For example, SELinux will now be able to utilize connection tracking, so 
that only packets which are known to be valid for a specific connection 
will be allowed to reach the subject.

Sample iptables rules for labeling packets are at:
http://people.redhat.com/jmorris/selinux/secmark/rules/

And examples of new policy controls may be found here:
http://people.redhat.com/jmorris/selinux/secmark/policy/


The sample policy for ftpd demonstrates how the vsftpd server can be 
confined so that it only receives SYN packets on the ftp control port for 
new connections, as well as any packets related to the ftp control or data 
connections and related ICMP packets.  It is also allowed to send DNS 
requests.

Note that only the per-packet network controls are being replaced -- the 
existing socket-based controls such as name_bind, node_bind and 
name_connect are being retained as they are useful for applications in 
that they return error messages in response to socket calls, and prevent, 
for example, an application from binding to specific local IP addresses.

Also, this local packet marking is orthogonal to the xfrm network labeling 
(which is for mediating access based on the security context of the 
endpoints across a network connection).


Please review these patches and let me know if there are any queries.

I would like to get the kernel components upstream in the 2.6.18 merge 
window.


- James
-- 
James Morris
<jmorris@namei.org>
