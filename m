From: Henrik Nordstrom <hno@marasystems.com>
Subject: Re: iptables API
Date: Tue, 15 Jun 2004 21:48:15 +0200 (CEST)
Sender: netfilter-devel-admin@lists.netfilter.org
Message-ID: <Pine.LNX.4.44.0406152146350.14121-100000@filer.marasystems.com>
References: <40CEC7B5.8080001@fokus.fraunhofer.de>
Mime-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Cc: netfilter-devel@lists.netfilter.org
Return-path: <netfilter-devel-admin@lists.netfilter.org>
To: John Williams Floroiu <floroiu@fokus.fraunhofer.de>
In-Reply-To: <40CEC7B5.8080001@fokus.fraunhofer.de>
Errors-To: netfilter-devel-admin@lists.netfilter.org
List-Help: <mailto:netfilter-devel-request@lists.netfilter.org?subject=help>
List-Post: <mailto:netfilter-devel@lists.netfilter.org>
List-Subscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=subscribe>
List-Unsubscribe: <https://lists.netfilter.org/mailman/listinfo/netfilter-devel>,
	<mailto:netfilter-devel-request@lists.netfilter.org?subject=unsubscribe>
List-Archive: <https://lists.netfilter.org/pipermail/netfilter-devel/>
List-Id: netfilter-devel.vger.kernel.org

On Tue, 15 Jun 2004, John Williams Floroiu wrote:

> to whom it may concern, C code to invoke the iptables is available here:
> http://www.mobile-ip.de/~jfl/using_iptables_API/

You do know about the iptables-restore command interface? This eleminates 
most if not all reasons to compile applications using the internal 
libiptc/libiptables interfaces..

Regards
Henrik
