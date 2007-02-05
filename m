From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: Need an iptables module for hiding NAT.
Date: Mon, 05 Feb 2007 17:09:44 +0100
Message-ID: <45C756C8.2010407@gmx.net>
References: <45C75479.3090605@arturaz.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Cc: netfilter-devel@lists.netfilter.org
To: =?UTF-8?B?QXJ0xatyYXMgxaBsYWp1cw==?= <x11@arturaz.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <45C75479.3090605@arturaz.net>
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

Artūras Šlajus wrote:
> I need iptables module which would hide NAT. It means that all traffic
> being routed through the machine which is running netfilter and doing
> routing should be seen as originating from that host.
> 
> I have searched the net and found this:
> http://lists.netfilter.org/pipermail/netfilter/2004-November/056947.html

I worked on IP Personality a few years ago. However, the netfilter
framework has changed a lot since then and I doubt much of the code
is reusable. It already had its share of problems with the netfilter
updates in the 2.4.x kernel series.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
