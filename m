From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: Sending back out A TCP Packet from netfilter
Date: Mon, 23 Feb 2004 08:33:18 +0100 (CET)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0402230831240.29722-100000@filer.marasystems.com>
References: <403979E9.8070300@hotmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Chee Yong TAN <chee_yong_tan@hotmail.com>
In-Reply-To: <403979E9.8070300@hotmail.com>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Mon, 23 Feb 2004, Chee Yong TAN wrote:

> What is the proper procedure in getting the packet send out back to the 
> network ?

See the REJECT iptables target for example on how this can be done.

Regards
Henrik
