From: Jeff Hall <hall@vdata.com>
Subject: Re: PPTP Conntrack and NAT
Date: Mon, 3 Mar 2003 00:30:29 -0500 (EST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.GSO.4.03.10303030014460.6286-100000@shemp.vdata.com>
References: <3E62B3AF.6090005@snapgear.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Philip Craig <philipc@snapgear.com>
In-Reply-To: <3E62B3AF.6090005@snapgear.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

   On Mon, 3 Mar 2003, Philip Craig wrote:
   
   Jeff Hall wrote:
   > I started with a base RH 7.2, downloaded 2.4-20 from kernel.org, downloaded
   > patch-o-matic-20030107, applied the V1.12 extra/pptp-contrack-nat.patch to
   > patch-o-matic, then installed the extra/pptp-conntrack-nat.patch and all
   > the pending patches.

   Okay.
   
   > Then I copied over the v1.7 ip_conntrack_pptp.c and
   > v1.3 ip_nat_pptp.c.
   
   Where you are getting these from?  Copying in these files will
   be overwriting the v1.12 extra/pptp-conntrack-nat.patch.

They are the latest versions in the netfilter-extensions/helpers/pptp cvs
repository. They were checked in by Harald and I believe they incorporate
your 20003/02/05 patches.
   
   > With this setup I am having the following problems:
   > 	I consistently received kernel panics until I inserted a "return 0"
   > 	just before the code in function pptp_expectfn in ip_conntrack_pptp.c
   > 	with the comment: /* delete other expectation */. The panic sited an
   > 	attempt to free a NULL pointer.
   
   I can't find this comment or any frees in pptp_expectfn() in
   any versions of ip_conntrack_pptp.c that I have.
   
   -- 
   Philip Craig - philipc@snapgear.com - http://www.SnapGear.com
   SnapGear - Custom Embedded Solutions and Security Appliances
   
   
