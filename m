From: zhi wang <pangy2004@yahoo.com>
Subject: Re: find_appropriate_src() BUG also exist in 2.4.24
Date: Mon, 5 Apr 2004 05:20:20 -0700 (PDT)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <20040405122020.40666.qmail@web41705.mail.yahoo.com>
References: <1081097427.1004.77.camel@tux.rsn.bth.se>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Cc: KOVACS Krisztian <piglet@sch.bme.hu>,
  Netfilter Develop <netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Martin Josefsson <gandalf@wlug.westbo.se>
In-Reply-To: <1081097427.1004.77.camel@tux.rsn.bth.se>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Yes, there are different. This bug is because get_unique_tuple blindly accepts
whatever find_appropriate_src returns in 2.4.x. While 2.6.5 has the return
tuple checked by ip_nat_used_tuple. You must have know this.:)

__________________________________
Do you Yahoo!?
Yahoo! Small Business $15K Web Design Giveaway 
http://promotions.yahoo.com/design_giveaway/
