From: Albrecht Melan <melan@isd.uni-stuttgart.de>
Subject: ip_conntrack_lock not readlocked
Date: Tue, 02 Jul 2002 16:11:37 +0200
Sender: netfilter-devel-admin@lists.samba.org
Message-ID: <3D21B499.141D270C@isd.uni-stuttgart.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-admin@lists.samba.org>
To: netfilter-devel@lists.samba.org
Errors-To: netfilter-devel-admin@lists.samba.org
List-Help: <mailto:netfilter-devel-request@lists.samba.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.samba.org>
List-Subscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=subscribe>
List-Unsubscribe: <http://lists.samba.org/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.samba.org?subject=unsubscribe>
List-Archive: <http://lists.samba.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi,

 I'm using a kernel of version 2.4.18 where module-support is disabled
together with iptables-1.2.6a ( all compiled by myself).
 I applied patches to netfilter  using POM.
 The following messages are seen in  my log-file
        ASSERT: ip_nat_core.c: 743 &ip_conntrack_lock not readlocked
        ASSERT:ip_conntrack_core.c: 973 &ip_conntrack_lock readlocked

  Has anybody an idea why this happens ?

 Thanks for your help
     Albrecht
