From: Chris Rankin <rankincj@yahoo.com>
Subject: 2.6.12: connection tracking broken?
Date: Sat, 18 Jun 2005 13:43:59 +0100 (BST)
Message-ID: <20050618124359.39052.qmail@web52901.mail.yahoo.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7BIT
Cc: linux-kernel@vger.kernel.org
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262105AbVFRMoH@vger.kernel.org>
To: netfilter-devel@lists.netfilter.org
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

Hi,

I have just tried upgrading my firewall to 2.6.12, but neither of the following rules in my
FORWARD table was allowing return traffic:

 1109  814K ACCEPT     all  --  ppp0   br0     anywhere             anywhere         ctstate
RELATED,ESTABLISHED
  11M   13G ACCEPT     all  --  ppp0   br0     anywhere             anywhere         state
RELATED,ESTABLISHED

I have currently returned to using 2.6.11.11, where the identical configuration works fine. br0 is
a bridge device containing two e100 devices, and ppp0 is my PPPoE DSL link. I am using iptables
1.3.1.

Cheers,
Chris



	
	
		
___________________________________________________________ 
Yahoo! Messenger - NEW crystal clear PC to PC calling worldwide with voicemail http://uk.messenger.yahoo.com
