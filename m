From: Denis Vlasenko <vda@ilport.com.ua>
Subject: Re: iptables redirect is broken on bridged setup
Date: Sat, 30 Jul 2005 17:40:13 +0300
Message-ID: <200507301740.13239.vda@ilport.com.ua>
References: <200507291209.37247.vda@ilport.com.ua> <20050729.123744.41648141.davem@davemloft.net>
Mime-Version: 1.0
Content-Type: text/plain;
  charset="koi8-r"
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org, linux-kernel@vger.kernel.org,
	coreteam@netfilter.org, laforge@netfilter.org, jmorris@redhat.com
Return-path: <linux-kernel-owner+glk-linux-kernel=40m.gmane.org-S262974AbVG3Oke@vger.kernel.org>
To: "David S. Miller" <davem@davemloft.net>
In-Reply-To: <20050729.123744.41648141.davem@davemloft.net>
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-Id: netfilter-devel.vger.kernel.org

On Friday 29 July 2005 22:37, David S. Miller wrote:
> From: Denis Vlasenko <vda@ilport.com.ua>
> Date: Fri, 29 Jul 2005 12:11:52 +0300
> 
> > Linux 2.6.12
> > 
> > Was running for months with this simple iptables rule:
>  ...
> > But now I need to bridge together two eth cards in this machine, and
> > suddenly redirect is no longer works.
> 
> I think this is the regression we fixed up in 2.6.12.x, can
> you try the latest 2.6.12.x stable release and see if it
> clears up this behavioral change?

Just tested. 2.6.12.3 does not have this bug.

Thanks!
--
vda
