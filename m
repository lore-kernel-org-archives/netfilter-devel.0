From: Noman Liaquat <khankhn1@yahoo.com>
Subject: STring Replacement Patch [Quick Response]
Date: Thu, 29 Dec 2005 02:42:08 -0800 (PST)
Message-ID: <20051229104208.27463.qmail@web35912.mail.mud.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org, rob@sterenborg.info,
	khankhn1@yahoo.com, mbr@cipherdyne.org,
	ishwar@pali.cps.cmich.edu, netfilter@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: m.d.berger@ieee.org, pablo@eurodev.net, george.john@ch.easynet.net
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


I  have downloaded the version of patch-o-matic-ng
from netfilter websites and now my patch of string
controlling is working, below command is the proof of
that

#iptables -A FORWARD -m string --algo bm --string
"hello" -j DROP

ok that is fine. is there any way to alter that
packet. to replace--string
is there any patch available, if yes so how i can
implement that patch. 
I am using kernel 2.6.14.4 and latest patch-o-matic-ng
from svn repository of netfilter website. i am using
RedHat Enterprise Linux version#4(ES).

this is the websites
 http://www.cipherdyne.org/fwsnort/

here iptables are providing --replace-string it is not
working fine giving errors to me.

I am waiting for quick response.

Regards
noman



	
		
__________________________________ 
Yahoo! for Good - Make a difference this year. 
http://brand.yahoo.com/cybergivingweek2005/
