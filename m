From: Nick Pasich <newsletters@NickAndBarb.net>
Subject: MAX_PORTS for ftp modules
Date: Mon, 26 Jan 2004 13:14:41 -0800
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040126211441.GA10833@66.27.62.2>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

 Hi,

 I've exhausted the MAX_PORTS limit of 8 for ftp using my own port id.

 I'm wondering if there are any repercussions in upping the limit to say,
 16 in the following modules.

 ip_conntrack_ftp.c:  #define MAX_PORTS 8
 ip_conntrack_irc.c:  #define MAX_PORTS 8
 ip_conntrack_tftp.c: #define MAX_PORTS 8
 ip_nat_ftp.c:        #define MAX_PORTS 8
 ip_nat_irc.c:        #define MAX_PORTS 8
 ip_nat_tftp.c:       #define MAX_PORTS 8


 I noticed that ipfwadm_core.c has "IP_FW_MAX_PORTS" which is defined in
 ipfwadm_core.h as 10.

 *********************************************************************************************************
 linux/include/linux/netfilter_ipv4/ipfwadm_core.h:#define IP_FW_MAX_PORTS  10 /* A reasonable maximum */
 *********************************************************************************************************
 
 So what modules need to be changed and what kind of trouble am I going to
 get into????
 
 
 I'm not subscribed to the newsletter, so please respond to me directly.
 
 
             Thanks,
 
             ---( Nick Pasich )---
