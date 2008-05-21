From: James Morris <jmorris@namei.org>
Subject: [PATCH 0/2] Security: Add security tables for mandatory access
 control
Date: Thu, 22 May 2008 00:17:23 +1000 (EST)
Message-ID: <Xine.LNX.4.64.0805220008510.3033@us.intercode.com.au>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: linux-security-module@vger.kernel.org,
	Paul Moore <paul.moore@hp.com>,
	Stephen Smalley <sds@tycho.nsa.gov>
To: netfilter-devel@vger.kernel.org
Return-path: <linux-security-module-owner@vger.kernel.org>
Sender: linux-security-module-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

The following patches add a new ip[6]tables "security" table, for use with 
mandatory access control (MAC) security schemes.

This follows on from an RFC post earlier in the year:
http://thread.gmane.org/gmane.linux.redhat.fedora.selinux/8490

In a nutshell, the need for this arises from the fact that MAC labeling 
rules utilizing iptables via SECMARK and CONNSECMARK are not subject to 
discretionary security policy (i.e. not even "root" or a user with 
CAP_NET_ADMIN may be able to modify these rules).

So, a separate table is proposed here to allow these administrative 
security domains to be separated, and specifically to assist with distro 
integration.

Patches for IPv4 and IPv6 follow.

Please review and consider for 2.6.27.


- James
-- 
James Morris
<jmorris@namei.org>
