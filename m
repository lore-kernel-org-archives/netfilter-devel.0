From: Chris Wilson <chris@netservers.co.uk>
Subject: [PATCH] New match module: byte rate match
Date: Mon, 20 Jan 2003 15:58:19 +0000 (GMT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0301161438250.2232-100000@localhost>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
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

Hi all,

NetServers.co.uk would like to submit a new module for your perusal and
hopefully for inclusion in Netfilter. It's based on ipt_limit, but matches
the number of bytes per second instead of the number of packets. This
means that it can be used for basic quality-of-service implementation,
thus:

# limit SMTP traffic from A to B to 4kbytes/s
iptables -A FORWARD -s A -d B -p tcp --dport 25 -m bytelimit --limit 
	4000/s -j ACCEPT
iptables -A FORWARD -s A -d B -p tcp --dport 25 -j DROP

# classify the first 8kbytes/s of SSH traffic as high priority
iptables -t mangle -A FORWARD -p tcp --dport 22 -m bytelimit --limit
        8000/s -j TOS --set-tos minimize-delay
iptables -t mangle -A FORWARD -p tcp --dport 22 -j TOS --set-tos normal

You can download the patches against iptables-1.2.7a userspace and kernel
2.4.19 here:

  'http://www.netservers.co.uk/gpl/iptables-bytelimit-030116.tar.gz'

And more information about us, including other GPL software, here:

  'http://www.netservers.co.uk/gpl/'

The module is licensed under the GPL, as it is based on ipt_limit. At this
stage, the module is only lightly tested, but it works for us. We hope it
will be useful to someone. 

Cheers, Chris.
-- 
   ___ __     _
 / __// / ,__(_)_  | Chris Wilson -- UNIX Firewall Lead Developer |
/ (_ / ,\/ _/ /_ \ | NetServers.co.uk http://www.netservers.co.uk |
\ _//_/_/_//_/___/ | 21 Signet Court, Cambridge, UK. 01223 576516 |
