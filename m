From: Andy Furniss <andy.furniss@dsl.pipex.com>
Subject: Re: The big Picture of all the tables ...
Date: Mon, 06 Jun 2005 22:08:22 +0100
Message-ID: <42A4BB46.70709@dsl.pipex.com>
References: <3abe8064b60ddf1a@mayday.cix.co.uk>
	<42A21418.7030008@outerspace.dyndns.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Robert de Bath <list-netfilter@debath.co.uk>,
	netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Jonas Berlin <xkr47@outerspace.dyndns.org>
In-Reply-To: <42A21418.7030008@outerspace.dyndns.org>
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

Jonas Berlin wrote:

> You might be interested in a picture I drew, with some help of Steven
> Van Acker:
> 
> http://xkr47.outerspace.dyndns.org/netfilter/packet_flow/packet_flow9.png

AIUI on recent kernels the Qos ingress box is only after PREROUTING if 
the kernel option packet action (CONFIG_NET_CLS_ACT) is not selected - 
if it is selected then ingress policers are before PREROUTING.

Andy.
