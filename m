From: "Daniel Chemko" <dchemko@smgtec.com>
Subject: A humble proposal
Date: Tue, 23 Sep 2003 09:13:21 -0700
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <7C9884991ADAE0479C14F10C858BCDF5122E46@alderaan.smgtec.com>
Mime-Version: 1.0
Content-Type: text/plain;
	charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
Return-path: <netfilter-devel-admin@lists.netfilter.org>
content-class: urn:content-classes:message
To: <netfilter@lists.netfilter.org>,
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

I have been researching some possible extensions to the Netfilter
environment, and something has become very necessary for my current
environment. The following proposal outlines what I wish to implement. I
am wondering if anyone would find value in this. Plus, I look forward to
feedback so that I may improve my ideas.


Problem:

When you need to have internet services open to the internet, some of
them are inherently insecure, such as FTP, SMB, etc. Even if the
protocols have built in encryption, there is still a chance that the
protocol can be compromised.

Also, I have a VPN connection into my internal network. I want anyone
connecting to be forced to authenticate to access mission-critical
components of the system, keeping them safe unless the user themselves
need to do emergency work on these servers.

Related:

While looking into PAM support for various Hardware Tokens, I can
across, pam_iptables. This allows one to login to a SSH, Telnet, or
whatever PAM supported daemon is installed with the module. Once
authenticated, the user has full TCP/IP access to the machine. Once the
SSH session has been closed, so does the iptables rule for access to the
system.

Suggestion:

I would like to take pam_iptables and expand it beyond its simple
structure. Features will include:

- Getting rid of the requirement to keep SSH open the whole time
- Create a daemon that keeps track of the sessions, instead of worrying
about the lifetime of the PAM session
- Allow iptables or any command to be executed once successful
authentication has occurred
- Customize the executed commands based on user/groups to give more fine
grained control over who has what protocol access
- Ability to expire sessions based on:
	- Upload/Download Quotas
	- Time in the system
	- Time idling on all services
	- Line Hang-up (VPN disconnect)
	- Other events that I can't think up on the spot

Since PAM returns the originating IP address of the request, most of the
rule functionality can be used to discriminate on a host level. I don't
think many people would have a problem with this. The only side effect
here is that a user behind a NAT'd network accessing the system opens
the services to everyone behind that host. This is unavoidable.

I have seen some of this functionality in Checkpoint, and I think that
it would be immensely useful in the iptables community if it is adopted.
