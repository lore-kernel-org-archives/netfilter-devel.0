From: "Gustavo Moreira" <gmoreira@gmail.com>
Subject: Extension for netfilter/iptables
Date: Mon, 4 Dec 2006 12:08:21 -0300
Message-ID: <c232498d0612040708y59105f13o9b3463790c4bbf32@mail.gmail.com>
References: <c232498d0612031417h4e746598o416858294e287b90@mail.gmail.com>
	<c232498d0612031601y2d7ffe5bj2b5c86a78ac42770@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <c232498d0612031601y2d7ffe5bj2b5c86a78ac42770@mail.gmail.com>
Content-Disposition: inline
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

Hi! .. I need to develop something like a Layer 4 Switch server for
protocols as SMTP and others. It cannot be proxy because it must
preserve the packet source IP to the backends servers. Also it would
be take actions according to the protocol and support great amount of
simultaneous connections. Is for this reason that I thought that an
netfilter/iptables extension could help me.
What do you think about?
Is really it appropriate?
Would it be a netfilter or iptables extension?
Is there any extension that I can take as example?

Any idea, help, guide will be welcome.

Regards, Gustavo
