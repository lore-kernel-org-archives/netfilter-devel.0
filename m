From: Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Subject: Re: Problem when writing a custom target for PRE and POST routing.
Date: Mon, 25 Sep 2006 23:48:16 +0200
Message-ID: <45184EA0.7030602@gmx.net>
References: <45184BB7.8000102@positivenetworks.net>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Wayne Schroeder <raz@positivenetworks.net>
In-Reply-To: <45184BB7.8000102@positivenetworks.net>
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

Wayne Schroeder wrote:
> I am working on a target module that will rewrite the source, dest, and
> mark of a packet.  A project I am doing cannot use the stateful nat for
> a few reasons.

Not directly answering your question, but IIRC in Linux 2.4 it was
possible to do stateless NAT with iproute2. That functionality has
been removed in Linux 2.6 because something broke.
http://lists.netfilter.org/pipermail/netfilter/2005-February/058950.html
http://linux-ip.net/html/nat-stateless.html

However, if you really want to perform stateless NAT with 2.6 kernels
and netfilter, the links above won't help you.

Regards,
Carl-Daniel
-- 
http://www.hailfinger.org/
