From: Patrick McHardy <kaber@trash.net>
Subject: Re: ip_queue & QUEUE target
Date: Sun, 15 Jun 2003 19:06:58 +0200
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <3EECA7B2.5090300@trash.net>
References: <20030615155352.GD2103@lbsd.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: Nigel Kukard <nkukard@lbsd.net>
In-Reply-To: <20030615155352.GD2103@lbsd.net>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

Hi Nigel,

Nigel Kukard wrote:

>Hi all,
>
>I have a very interesting problem, I have all packets passing through my
>firewall being thrown to userspace with -j QUEUE, I them pick certain
>packets and generate statistics.
>
>My problem comes when I do a ping -f, at random times will my small
>program just not receive any packets. I'm using ipq_read with a timeout
>of 250000ms. I also get "Timeout" error messages when using ping -f.
>
>I've tried to re-open the IPQ handle each time it fails, to no avail.
>
>
>does anyone know how i can solve this problem?
>  
>

netlink sockets provide unreliable communication. your problem is
probably the sockets receive queue overflowing. ip_queue then
returns a negative error code to nf_queue which drops the packet.

Hope that helps,
Patrick

>Regars
>
>Nigel Kukard
>
>  
>
