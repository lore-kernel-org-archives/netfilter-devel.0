From: Martijn Lievaart <m@rtij.nl>
Subject: Re: [PATCH 2.6] Allow dynamic helper-port assignment
Date: Mon, 14 Feb 2005 13:20:55 +0100
Message-ID: <421097A7.3090006@rtij.nl>
References: <20050213165638.GM20269@sunbeam.de.gnumonks.org>
	<421092AC.30709@rtij.nl>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Transfer-Encoding: 7bit
Cc: Harald Welte <laforge@netfilter.org>
To: Netfilter Development Mailinglist <netfilter-devel@lists.netfilter.org>
In-Reply-To: <421092AC.30709@rtij.nl>
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

Martijn Lievaart wrote:

> Additional ports can be registered with a target, f.i. "-p tcp -p 666 
> -s <someip> -j HELP --helper ftp". This would add a helper for this 
> specific connection. Obviously, people that load modules with 


Raaah. Engage brain before typing.

s/-p 666/--dport 666/

M4
