From: "David S. Miller" <davem@davemloft.net>
Subject: Re: iptables redirect is broken on bridged setup
Date: Fri, 29 Jul 2005 12:37:44 -0700 (PDT)
Message-ID: <20050729.123744.41648141.davem@davemloft.net>
References: <200507291209.37247.vda@ilport.com.ua>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	coreteam@netfilter.org, laforge@netfilter.org, jmorris@redhat.com
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262756AbVG2Tli@vger.kernel.org>
To: vda@ilport.com.ua
In-Reply-To: <200507291209.37247.vda@ilport.com.ua>
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

From: Denis Vlasenko <vda@ilport.com.ua>
Date: Fri, 29 Jul 2005 12:11:52 +0300

> Linux 2.6.12
> 
> Was running for months with this simple iptables rule:
 ...
> But now I need to bridge together two eth cards in this machine, and
> suddenly redirect is no longer works.

I think this is the regression we fixed up in 2.6.12.x, can
you try the latest 2.6.12.x stable release and see if it
clears up this behavioral change?
