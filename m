From: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Subject: Re[2]: TCP Connection tracking and SYN/ACK/PSH
Date: Wed, 20 Apr 2005 09:02:16 +0200
Message-ID: <1835059650.20050420090216@dns.toxicfilms.tv>
References: <20050417193718.6a7f0809.gniibe@fsij.org>
	<Pine.LNX.4.61.0504180316120.4321@filer.marasystems.com>
	<4265B0B7.5090707@variosecure.net>
Reply-To: Maciej Soltysiak <solt@dns.toxicfilms.tv>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: netfilter-devel@lists.netfilter.org
In-Reply-To: <4265B0B7.5090707@variosecure.net>
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

Hello Tim,

Wednesday, April 20, 2005, 3:30:31 AM, you wrote:
> the meantime, we modified our rules to allow INVALID traffic to/from the
> device. Obviously it's not ideal, but it gets the job done. If Panasonic
> is unable/unwilling to fix the TCP behavior, we would probably patch
> Netfilter to clear the PSH flag when it occurs in combination with SYN.
I guess this is material for a FAQ item...
And maybe for the INCOMPATIBILITIES file that sits around in /iptables

> Tim
Maciej
