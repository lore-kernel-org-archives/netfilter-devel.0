From: "NICOLAS BOULIANE" <nicboul@gmail.com>
Subject: Re: [NETFILTER 13/50]: x_tables: mark matches and targets
	__read_mostly
Date: Sat, 7 Jul 2007 08:59:40 -0500
Message-ID: <dd45289d0707070659r223e0efbl125bd799b319986b@mail.gmail.com>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
	<20070707122235.1589.25449.sendpatchset@localhost.localdomain>
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Cc: netfilter-devel@lists.netfilter.org
To: "Patrick McHardy" <kaber@trash.net>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <20070707122235.1589.25449.sendpatchset@localhost.localdomain>
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

On 7/7/07, Patrick McHardy <kaber@trash.net> wrote:
> [NETFILTER]: x_tables: mark matches and targets __read_mostly

How many time will those structures get read ?
Only one when loaded or several times ?

> A read_mostly marked variable should be changed rarely (meaning is
> is extremely unlikely that his is going to change) but read frequently.
http://www.ussg.iu.edu/hypermail/linux/kernel/0606.3/0721.html


Thanks in advance for the explanation.

--
acidfu
