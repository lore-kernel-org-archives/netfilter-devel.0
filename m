From: Patrick McHardy <kaber@trash.net>
Subject: Re: [NETFILTER 13/50]: x_tables: mark matches and targets
	__read_mostly
Date: Sat, 7 Jul 2007 16:50:09 +0200 (CEST)
Message-ID: <Pine.LNX.4.64.0707071649440.1764@x2>
References: <20070707122215.1589.12100.sendpatchset@localhost.localdomain>
	<20070707122235.1589.25449.sendpatchset@localhost.localdomain>
	<dd45289d0707070659r223e0efbl125bd799b319986b@mail.gmail.com>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
Cc: netfilter-devel@lists.netfilter.org
To: NICOLAS BOULIANE <nicboul@gmail.com>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
In-Reply-To: <dd45289d0707070659r223e0efbl125bd799b319986b@mail.gmail.com>
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

On Sat, 7 Jul 2007, NICOLAS BOULIANE wrote:

> On 7/7/07, Patrick McHardy <kaber@trash.net> wrote:
>> [NETFILTER]: x_tables: mark matches and targets __read_mostly
>
> How many time will those structures get read ?
> Only one when loaded or several times ?


On ruleset changes and in some cases during packet processing.
