From: Patrick McHardy <kaber@trash.net>
Subject: Re: Compilation error: nf_debug in nfnetlink.c
Date: Fri, 05 Dec 2003 19:26:22 +0100
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3FD0CDCE.4040700@trash.net>
References: <Pine.LNX.4.44.0312051843090.4858-100000@filer.marasystems.com> <3FD0C640.50801@netlab.hut.fi>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Henrik Nordstrom <hno@marasystems.com>,
 netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: emmanuel@netlab.hut.fi
In-Reply-To: <3FD0C640.50801@netlab.hut.fi>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Emmanuel Guiton wrote:
> Sorry, I was thinking about GNU make...
> gcc version 2.95.4
> 
> Ok, it seems old, I change it, thanks.


It's a good version, but apparently there is a bug which requires a 
space in the define. See the other nfnetlink message to netfilter-devel
yesterday.

Best regards,
Patrick
