From: Ian Chilton <mailinglist@ichilton.co.uk>
Subject: iptables Error - "Memory allocation problem"
Date: Thu, 5 Dec 2002 01:24:32 +0000
Sender: user-mode-linux-devel-admin@lists.sourceforge.net
Message-ID: <20021205012432.GB18233@buzz.ichilton.co.uk>
Reply-To: Ian Chilton <ian@ichilton.co.uk>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Return-path: <user-mode-linux-devel-admin@lists.sourceforge.net>
To: user-mode-linux-devel@lists.sourceforge.net,
	linux-kernel@vger.kernel.org, netfilter-devel@lists.netfilter.org
Content-Disposition: inline
Errors-To: user-mode-linux-devel-admin@lists.sourceforge.net
List-Help: <mailto:user-mode-linux-devel-request@lists.sourceforge.net?subject=help>
List-Post: <mailto:user-mode-linux-devel@lists.sourceforge.net>
List-Subscribe: <https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel>,
	<mailto:user-mode-linux-devel-request@lists.sourceforge.net?subject=subscribe>
List-Unsubscribe: <https://lists.sourceforge.net/lists/listinfo/user-mode-linux-devel>,
	<mailto:user-mode-linux-devel-request@lists.sourceforge.net?subject=unsubscribe>
List-Archive: <http://sourceforge.net/mailarchive/forum.php?forum=user-mode-linux-devel>
List-Id: netfilter-devel.vger.kernel.org

Hello,

I have a uml (user mode linux) instance with a debian/testing root
running on an Intel P200MMX with 96MB RAM. The host is running
2.4.20-fairsched-skas3 and the uml is 2.4.19-34um.


On boot when it loads my firewall, I get this:

Starting Firewall... /scripts/firewall: line 26:   109 Segmentation
fault      iptables -F
iptables v1.2.7a: can't initialize iptables table `filter': Memory
allocation problem
Perhaps iptables or your kernel needs to be upgraded.


The uml then locks solid. Anyone seen this before or have any ideas?

[ Please CC replies to me as well as the list(s) ]


Thanks in Advance!

Ian



-------------------------------------------------------
This SF.net email is sponsored by: Microsoft Visual Studio.NET 
comprehensive development tool, built to increase your 
productivity. Try a free online hosted session at:
http://ads.sourceforge.net/cgi-bin/redirect.pl?micr0003en
