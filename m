From: Jim Pick <jim@jimpick.com>
Subject: Masquerading problems - XenU 3.0 on x86_64
Date: Sat, 08 Apr 2006 17:01:30 -0700
Message-ID: <44384EDA.2080106@jimpick.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <xen-devel-bounces@lists.xensource.com>
To: "xen-devel@lists.xensource.com" <xen-devel@lists.xensource.com>
List-Unsubscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=unsubscribe>
List-Post: <mailto:xen-devel@lists.xensource.com>
List-Help: <mailto:xen-devel-request@lists.xensource.com?subject=help>
List-Subscribe: <http://lists.xensource.com/cgi-bin/mailman/listinfo/xen-devel>,
	<mailto:xen-devel-request@lists.xensource.com?subject=subscribe>
Sender: xen-devel-bounces@lists.xensource.com
Errors-To: xen-devel-bounces@lists.xensource.com
List-Id: netfilter-devel.vger.kernel.org

Hi,

I'm trying to migrate my Xen sessions installed on 32-bit Xen 2.0 server 
to a 64-bit Xen 3.0 server.

On the Xen 2.0 server (32-bit), I built a DomU kernel with masquerading, 
and I use that to do NAT for some private networks running on the same 
box.

When I tried to do it with Xen 3.0 (64-bit), I couldn't get it to work. 
  I had to build a custom DomU kernel (from xen-3.0-testing.hg, 2.6.16, 
2 days ago) in order to include the netfilter/iptables code.  ICMP 
works.  TCP doesn't.  Non-masquerading traffic is OK.  I had the same 
problems with the 2.6.12 kernel from Xen 3.0.1.

I captured some of the traffic, and ethereal is showing that the 
masqueraded traffic being output has bad TCP checksums.

I'm going to have to do some debugging to try to figure out what's going 
wrong.

Has anybody else encountered this?  Also, if it's already been fixed 
somewhere, I'd love to know.  Any Netfilter debugging tips would also be 
appreciated.

Cheers,

  - Jim
