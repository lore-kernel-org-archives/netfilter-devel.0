From: Alexander Gun <Alexander.Gun@gmx.de>
Subject: NAT and NFS
Date: Thu, 20 Mar 2003 00:42:02 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20030319234202.GB29301@gunix.de>
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

hi all

is it possible to share a nfs-filesystem via a NATed host ?



        ----------------
	- NFS - Server -
	----------------
	       + 129.187...
               +
	       +
	       +
	       + 129.187....
	----------------
	-   NAT Host   -
	----------------
               + 192.168....
	      +++
	     + + +
	    +  +  +
	   +   +   +
	  +    +    +
	 +     +     +
	+      +      +
       +       +       +  192.168...
 ------------------------------
NFS client1    client2   client3 ....
-------------------------------


question: is it possible or not ?

mfg
ag



-- 
-------------------------------------------
in a world without fences
   ---   who needs gates ???
