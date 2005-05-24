From: Max Kellermann <max@duempel.org>
Subject: Re: Writing new Netfilter Modules
Date: Tue, 24 May 2005 13:06:32 +0200
Message-ID: <20050524110632.GA4178@roonstrasse.net>
References: <6B6D4D4E2ED1D6119DB80000D11D813EB4CA6F@blns203e.bln.icn.siemens.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Transfer-Encoding: 8bit
Cc: "'netfilter-devel@lists.netfilter.org'"
	<netfilter-devel@lists.netfilter.org>
Return-path: <netfilter-devel-bounces@lists.netfilter.org>
To: Gingold Tomasz <tomasz.gingold@siemens.com>
Content-Disposition: inline
In-Reply-To: <6B6D4D4E2ED1D6119DB80000D11D813EB4CA6F@blns203e.bln.icn.siemens.de>
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

On 2005/05/24 12:58, Gingold Tomasz <tomasz.gingold@siemens.com> wrote:
> Up to now i have found the "Linux netfilter Hacking HOWTO", especially
> chapter 4 "Information for Programmers.
> Is this the only help i can obtain?

afaik, yes. Use the source, Luke ;) - reading the source of simple
netfilter modules may give you an idea how to start.

> Another question: I have found on www.netfilter.org
> <www.netfilter.org> the following statement: "netfilter and iptables
> are building blocks of a framework inside the Linux
> <http://www.kernel.org/> 2.4.x and 2.6.x kernel" Does this mean,
> that netfilter and iptables are part of the kernel and don´t have to
> be installed?

iptables is the userspace frontend for netfilter (i.e. it's not part
of the kernel), and needs to be installed. Netfilter itself is
compiled into the kernel.

Max
